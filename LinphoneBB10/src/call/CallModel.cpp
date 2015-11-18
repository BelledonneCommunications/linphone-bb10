/*
 * CallModel.cpp
 * Copyright (C) 2015  Belledonne Communications, Grenoble, France
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 *
 *  Created on: 19 mars 2015
 *      Author: Sylvain Berfini
 */

#include "CallModel.h"
#include "src/contacts/ContactFetcher.h"
#include "src/linphone/LinphoneManager.h"
#include "src/utils/Misc.h"

#include <bb/cascades/OrientationSupport>

using namespace bb::cascades;

CallModel::CallModel(QObject *parent) :
        QObject(parent),
        window_id(NULL),
        window_group(NULL),
        _pausedCallsDataModel(new GroupDataModel(this)),
        _conferenceCallsDataModel(new GroupDataModel(this)),
        _callStatsModel(new CallStatsModel(this)),
        _currentCall(NULL),
        _incomingCall(NULL),
        _outgoingCall(NULL),
        _isVideoEnabled(false),
        _videoUpdateInProgress(false),
        _isMicMuted(false),
        _isSpeakerEnabled(false),
        _areControlsVisible(true),
        _statsTimer(new QTimer(this)),
        _acceptCallUpdateTimer(new QTimer(this)),
        _dialerCallButtonMode(0),
        _deviceOrientation(0),
        _previewSize(QSize(0, 0)),
        _mediaInProgress(false),
        _acceptCallUpdatedByRemoteVisible(false),
        _callUpdatedByRemote(NULL),
        _isPausedByRemote(false)
{
    _pausedCallsDataModel->setGrouping(ItemGrouping::None);
    _pausedCallsDataModel->setSortedAscending(false);
    _conferenceCallsDataModel->setGrouping(ItemGrouping::None);
    _conferenceCallsDataModel->setSortedAscending(false);

    bool result = QObject::connect(LinphoneManager::getInstance(), SIGNAL(callStateChanged(LinphoneCall*)), this, SLOT(callStateChanged(LinphoneCall*)));
    Q_ASSERT(result);

    result = QObject::connect(LinphoneManager::getInstance(), SIGNAL(callEncryptionChanged(LinphoneCall*)), this, SLOT(callEncryptionChanged(LinphoneCall*)));
    Q_ASSERT(result);

    result = QObject::connect(_statsTimer, SIGNAL(timeout()), this, SLOT(statsTimerTimeout()));
    Q_ASSERT(result);

    result = QObject::connect(_acceptCallUpdateTimer, SIGNAL(timeout()), this, SLOT(acceptCallUpdatedByRemoteTimeout()));
    Q_ASSERT(result);

    result = connect(OrientationSupport::instance(), SIGNAL(displayDirectionAboutToChange(bb::cascades::DisplayDirection::Type, bb::cascades::UIOrientation::Type)), this, SLOT(onOrientationAboutToChange(bb::cascades::DisplayDirection::Type, bb::cascades::UIOrientation::Type)));
    Q_ASSERT(result);

    // Set the current rotation of the device
    UIOrientation::Type currentOrientation = OrientationSupport::instance()->orientation();
    DisplayDirection::Type displayDirection = OrientationSupport::instance()->displayDirection();
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    if (currentOrientation == UIOrientation::Landscape) {
        _deviceOrientation = displayDirection;
        emit deviceOrientationChanged();
    }
    ms_debug("[BB10] default device orientation: %s", _deviceOrientation == 0 ? "portrait" : "landscape");
    linphone_core_set_device_rotation(lc, _deviceOrientation);

    _statsTimer->setInterval(1000);
    _acceptCallUpdateTimer->setInterval(30000);

    Q_UNUSED(result);
}

static LinphoneCall* getCurrentCall()
{
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    if (linphone_core_get_calls_nb(lc) == 0) {
        return NULL;
    }

    LinphoneCall *call = linphone_core_get_current_call(lc);
    if (!call) {
        const MSList *calls = linphone_core_get_calls(lc);
        call = (LinphoneCall *) ms_list_nth_data(calls, 0);
    }

    return call;
}

void CallModel::callEncryptionChanged(LinphoneCall *call) {
    if (call && !linphone_call_get_authentication_token_verified(call)) {
        _callStatsModel->showZRTPDialog(call);
    }
}

void CallModel::callStateChanged(LinphoneCall *call) {
    if (!call) {
        call = getCurrentCall();
    }
    if (!call) {
        return;
    }

    LinphoneCallState state = linphone_call_get_state(call);

    const LinphoneCallParams *params = linphone_call_get_current_params(call);
    const LinphoneAddress *addr = linphone_call_get_remote_address(call);
    QString sipUri = linphone_address_as_string_uri_only(addr);

    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();

    if (state == LinphoneCallIncomingReceived || state == LinphoneCallOutgoingInit) {
        if (!_statsTimer->isActive()) {
            _statsTimer->start();
        }

        ContactFound contact = ContactFetcher::getInstance()->findContact(linphone_address_get_username(addr));
        QString displayName, photo, sipUri;
        if (contact.id >= 0) {
            displayName = contact.displayName;
            photo = contact.picturePath;
        } else {
            displayName = GetDisplayNameFromLinphoneAddress(addr);
            photo = "/images/avatar.png";
        }

        LinphoneCallModel *model = new LinphoneCallModel(this, call, GetAddressFromLinphoneAddress(addr), displayName, photo);
        linphone_call_set_user_data(call, model);

        if (state == LinphoneCallIncomingReceived) {
            _incomingCall = model;
            emit incomingCallChanged();
        } else {
            _outgoingCall = model;
            emit outgoingCallChanged();
        }
    } else if (state == LinphoneCallEnd || state == LinphoneCallError) {
        LinphoneCallModel *model = (LinphoneCallModel *)linphone_call_get_user_data(call);
        delete(model);
        linphone_call_set_user_data(call, NULL);

        conferenceCalls();

        if (linphone_core_get_calls_nb(lc) == 0) {
            if (_statsTimer->isActive()) {
                _statsTimer->stop();
            }

            _isSpeakerEnabled = false;
            _isMicMuted = false;
            _isVideoEnabled = false;
            emit callControlsUpdated();
            emit conferenceUpdated();
        }
    } else if (state == LinphoneCallStreamsRunning) {
        _videoUpdateInProgress = false;
        _mediaInProgress = linphone_call_media_in_progress(call);
        emit mediaInProgressUpdated();

        _currentCall = (LinphoneCallModel *)linphone_call_get_user_data(call);
        emit currentCallChanged();

        _isPausedByRemote = false;
        emit callPausedByRemoteUpdated();

        setVideoEnabled(linphone_call_params_video_enabled(params));
        setMicMuted(linphone_core_is_mic_muted(lc));
    } else if (state == LinphoneCallUpdatedByRemote) {
        bool localVideoEnabled = linphone_call_params_video_enabled(linphone_call_get_current_params(call));
        bool remoteVideoEnabled = linphone_call_params_video_enabled(linphone_call_get_remote_params(call));
        bool autoAcceptVideoPolicy = linphone_core_get_video_policy(lc)->automatically_accept;
        if (!localVideoEnabled && remoteVideoEnabled && !autoAcceptVideoPolicy) {
            linphone_core_defer_call_update(lc, call);
            _acceptCallUpdateTimer->start();
            _acceptCallUpdatedByRemoteVisible = true;
            _callUpdatedByRemote = call;
            emit callUpdatedByRemote();
        }
    } else if (state == LinphoneCallPausedByRemote) {
        _isPausedByRemote = true;
        emit callPausedByRemoteUpdated();
    }

    pausedCalls();

    emit callStateChanged();
}

void CallModel::onOrientationAboutToChange(DisplayDirection::Type displayDirection, UIOrientation::Type uiOrientation) {
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();

    if (uiOrientation == UIOrientation::Landscape) {
        _deviceOrientation = displayDirection;
    } else {
        _deviceOrientation = 0;
    }

    ms_debug("[BB10] device orientation about to change to %s", _deviceOrientation == 0 ? "portrait" : "landscape");
    linphone_core_set_device_rotation(lc, _deviceOrientation);
    emit deviceOrientationChanged();

    LinphoneCall *call = getCurrentCall();
    if (call) {
        linphone_core_update_call(lc, call, NULL);
    }
}

void CallModel::updateCallTimerInPausedAndConferenceCalls() {
    foreach (QVariantMap variant, _pausedCallsDataModel->toListOfMaps()) {
        LinphoneCallModel *model = variant["call"].value<LinphoneCallModel*>();
        if (!model) {
            continue;
        }
        QVariantList indexPath = _pausedCallsDataModel->findExact(variant);
        variant["callTime"] = model->callTime();
        _pausedCallsDataModel->updateItem(indexPath, variant);
    }

    emit pausedCallsUpdated();

    foreach (QVariantMap variant, _conferenceCallsDataModel->toListOfMaps()) {
        LinphoneCallModel *model = variant["call"].value<LinphoneCallModel*>();
        if (!model) {
            continue;
        }
        QVariantList indexPath = _conferenceCallsDataModel->findExact(variant);
        variant["callTime"] = model->callTime();
        _conferenceCallsDataModel->updateItem(indexPath, variant);
    }

    emit conferenceUpdated();
}

void CallModel::statsTimerTimeout()
{
    updateCallTimerInPausedAndConferenceCalls();

    LinphoneCall *call = getCurrentCall();
    if (!call) {
        emit statsUpdated();
        return;
    }

    if (_callStatsModel) {
        _callStatsModel->updateStats(call);
    }

    const LinphoneCallParams *params = linphone_call_get_current_params(call);
    MSVideoSize vsize = linphone_call_params_get_sent_video_size(params);
    MSVideoSize maxSize = ms_video_size_make(320, 240);
    if (vsize.width < vsize.height) {
        maxSize = ms_video_size_make(240, 320);
    }
    vsize = ms_video_size_min(maxSize, vsize);
    _previewSize.setWidth(vsize.width);
    _previewSize.setHeight(vsize.height);

    emit statsUpdated();
}

void CallModel::acceptCallUpdate(bool accept) {
    if (_acceptCallUpdateTimer->isActive()) {
        _acceptCallUpdateTimer->stop();
    }

    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    LinphoneCall *call = _callUpdatedByRemote;

    if (call) {
        const LinphoneCallParams *params = linphone_call_get_current_params(call);
        LinphoneCallParams *params_copy = linphone_call_params_copy(params);
        if (accept) {
            linphone_call_params_enable_video(params_copy, true);
        }
        linphone_core_accept_call_update(lc, call, params_copy);
    }

    _callUpdatedByRemote = NULL;
    _acceptCallUpdatedByRemoteVisible = false;
    emit callUpdatedByRemote();
}

void CallModel::acceptCallUpdatedByRemoteTimeout()
{
    acceptCallUpdate(false);
}

void CallModel::switchFullScreenMode()
{
    _areControlsVisible = !_areControlsVisible;
    emit fullScreenModeSwitched();
}

void CallModel::onVideoSurfaceCreationCompleted(QString id, QString group)
{
    window_group = strdup(group.toUtf8().constData());
    window_id = strdup(id.toUtf8().constData());

    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    linphone_core_set_native_video_window_id(lc, (void*) window_group);
    linphone_core_set_native_preview_window_id(lc, (void*) window_group);
    ms_debug("[BB10] Video window id: %s and group %s", window_id, window_group);
}

void CallModel::cameraPreviewAttached(screen_window_t handle) {
    int z = -4; // -5 is the remote video
    screen_set_window_property_iv(handle, SCREEN_PROPERTY_ZORDER, &z);
}

void CallModel::accept(LinphoneCallModel *callModel) {
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();

    if (callModel == NULL) {
        return;
    }

    LinphoneCall *call = callModel->_call;
    if (call) {
        linphone_core_accept_call(lc, call);
    }
}

void CallModel::hangUp(LinphoneCallModel *callModel)
{
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();

    if (callModel == NULL) {
        return;
    }

    LinphoneCall *call = callModel->_call;
    if (call) {
        linphone_core_terminate_call(lc, call);
    }
}

void CallModel::hangUp()
{
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();

    if (linphone_core_is_in_conference(lc)) {
        linphone_core_terminate_conference(lc);
        emit conferenceUpdated();
        return;
    }

    LinphoneCall *call = NULL;
    if (_currentCall) {
        call = _currentCall->_call;
    }

    if (!call) {
        call = getCurrentCall();
    }

    if (call) {
        linphone_core_terminate_call(lc, call);
    }
}

void CallModel::setVideoEnabled(const bool &enabled)
{
    if (enabled == _isVideoEnabled) {
        return;
    }

    _isVideoEnabled = enabled;

    if (_isVideoEnabled) {
        switchFullScreenMode();
    } else {
        _areControlsVisible = true;
        emit fullScreenModeSwitched();
    }

    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    LinphoneCall *call = getCurrentCall();
    if (!call) {
        return;
    }

    const LinphoneCallParams *cp = linphone_call_get_current_params(call);
    LinphoneCallParams *params = linphone_call_params_copy(cp);
    if (linphone_call_params_video_enabled(params) != _isVideoEnabled) {
        _videoUpdateInProgress = true;
        linphone_call_params_enable_video(params, enabled);
        linphone_core_update_call(lc, call, params);
    }
}

void CallModel::setMicMuted(const bool &muted)
{
    if (muted == _isMicMuted) {
        return;
    }

    _isMicMuted = muted;

    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    linphone_core_mute_mic(lc, muted);

    emit callControlsUpdated();
}

void CallModel::setSpeakerEnabled(const bool &enabled)
{
    if (enabled == _isSpeakerEnabled) {
        return;
    }

    LinphoneCall *call = getCurrentCall();
    if (call) {
        _isSpeakerEnabled = enabled;
        LinphoneAudioRoute route = _isSpeakerEnabled ? LinphoneAudioRouteSpeaker : LinphoneAudioRouteEarpiece;
        linphone_call_set_audio_route(call, route);
        emit callControlsUpdated();
    }
}

void CallModel::switchCamera()
{
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    LinphoneCall *call = getCurrentCall();
    if (!call) {
        return;
    }

    const char **videoDevices = linphone_core_get_video_devices(lc);
    const char *videoDeviceId = linphone_core_get_video_device(lc);
    const char *newVideoDeviceId = NULL;

    for (int i = 0; videoDevices[i] != NULL; ++i) {
        if (strcmp(videoDevices[i], "StaticImage: Static picture") == 0)
            continue;
        if (strcmp(videoDevices[i], videoDeviceId) != 0) {
            newVideoDeviceId = videoDevices[i];
            break;
        }
    }
    if (newVideoDeviceId) {
        linphone_core_set_video_device(lc, newVideoDeviceId);
        linphone_core_update_call(lc, call, NULL);
    }
}

void CallModel::pauseCurrentCall()
{
    LinphoneCall *call = getCurrentCall();
    if (!call) {
        return;
    }

    LinphoneCallState state = linphone_call_get_state(call);
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    if (lc) {
        if (state == LinphoneCallStreamsRunning || state == LinphoneCallPausedByRemote) {
            linphone_core_pause_call(lc, call);
        }
    }
}

void CallModel::resumeCall(const LinphoneCallModel*& callModel) {
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();

    if (lc) {
        if (callModel) {
            LinphoneCallState state = linphone_call_get_state(callModel->_call);
            if (state == LinphoneCallPaused) {
                linphone_core_resume_call(lc, callModel->_call);
            }
        } else {
            const MSList *calls = linphone_core_get_calls(lc);
            bool isConference = false;
            while (calls) {
                LinphoneCall *call = (LinphoneCall*) calls->data;
                const LinphoneCallParams *params = linphone_call_get_current_params(call);
                if (linphone_call_params_get_local_conference_mode(params)) {
                    isConference = true;
                    break;
                }
            }

            if (isConference && !linphone_core_is_in_conference(lc)) {
                // Conference is paused, resume it
                linphone_core_enter_conference(lc);
                pausedCalls();
            }
        }
    }
}

bool CallModel::isInCall() const {
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    return linphone_core_get_calls_nb(lc) > 0;
}

void CallModel::updateZRTPTokenValidation(bool isTokenOk) {
    LinphoneCall *call = getCurrentCall();
    if (call) {
        linphone_call_set_authentication_token_verified(call, isTokenOk);
        _callStatsModel->updateStats(call);
    }
}

bool CallModel::isCallTransferAllowed() const {
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    return linphone_core_get_current_call(lc) != NULL;
}

bool CallModel::isMultiCallAllowed() const {
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    return linphone_core_get_max_calls(lc) > linphone_core_get_calls_nb(lc);
}

bool CallModel::isConferenceAllowed() const {
    int count = 0;
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    const MSList *calls = linphone_core_get_calls(lc);

    while (calls) {
        LinphoneCall *call = (LinphoneCall*)calls->data;
        if (call && !linphone_call_is_in_conference(call)) {
            count++;
        }
        calls = ms_list_next(calls);
    }

    return (linphone_core_is_in_conference(lc) && count >= 1) || count >= 2;
}

int CallModel::runningCallsNotInAnyConferenceCount() const {
    int count = 0;
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    const MSList *calls = linphone_core_get_calls(lc);

    while (calls) {
        LinphoneCall *call = (LinphoneCall*)calls->data;
        if (call && linphone_call_get_state(call) != LinphoneCallPaused && !linphone_call_is_in_conference(call)) {
            count++;
        }
        calls = ms_list_next(calls);
    }

    return count;
}

void CallModel::pausedCalls() {
    if (_pausedCallsDataModel == NULL) {
        return;
    }
    _pausedCallsDataModel->clear();

    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    const MSList *calls = linphone_core_get_calls(lc);

    int conferenceCount = 0;
    while (calls) {
        LinphoneCall *call = (LinphoneCall*) calls->data;
        const LinphoneCallParams *params = linphone_call_get_current_params(call);
        if (linphone_call_params_get_local_conference_mode(params)) {
            conferenceCount++;
        }

        if (linphone_call_get_state(call) == LinphoneCallPaused) {
            QVariantMap entry;
            LinphoneCallModel *model = (LinphoneCallModel *)linphone_call_get_user_data(call);
            entry["call"] = QVariant::fromValue<LinphoneCallModel*>(model);
            entry["displayName"] = model->displayName();
            entry["photo"] = model->photo();
            entry["callTime"] = model->callTime();
            _pausedCallsDataModel->insert(entry);
        }
        calls = ms_list_next(calls);
    }

    if (conferenceCount > 1 && !linphone_core_is_in_conference(lc)) { // Conference is paused
        QVariantMap entry;
        entry["displayName"] = tr("Conference");
        entry["photo"] = "/images/avatar.png";
        _pausedCallsDataModel->insert(entry);
    }

    emit pausedCallsUpdated();
}

bool CallModel::isInConference() const {
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    return linphone_core_get_calls_nb(lc) > 1 && linphone_core_is_in_conference(lc);
}

void CallModel::startConference() {
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();

    if (linphone_core_get_calls_nb(lc) < 2) {
        return;
    }

    linphone_core_add_all_to_conference(lc);
    emit conferenceUpdated();

    conferenceCalls();
}

void CallModel::conferenceCalls() {
    if (_conferenceCallsDataModel == NULL) {
        return;
    }
    _conferenceCallsDataModel->clear();

    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    const MSList *calls = linphone_core_get_calls(lc);

    while (calls) {
        LinphoneCall *call = (LinphoneCall*) calls->data;
        if (call && linphone_call_is_in_conference(call)) {
            QVariantMap entry;
            LinphoneCallModel *model = (LinphoneCallModel *)linphone_call_get_user_data(call);
            entry["call"] = QVariant::fromValue<LinphoneCallModel*>(model);
            entry["displayName"] = model->displayName();
            entry["photo"] = model->photo();
            entry["callTime"] = model->callTime();
            _conferenceCallsDataModel->insert(entry);
        }
        calls = ms_list_next(calls);
    }

    emit conferenceUpdated();
}

void CallModel::ejectFromConference(const LinphoneCallModel*& callModel) {
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();

    if (lc && callModel) {
        if (linphone_call_is_in_conference(callModel->_call)) {
            linphone_core_remove_from_conference(lc, callModel->_call);

            conferenceCalls();
        }
    }
}
