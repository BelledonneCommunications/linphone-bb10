/*
 * InCallModel.cpp
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

#include "InCallModel.h"
#include "src/contacts/ContactFetcher.h"
#include "src/linphone/LinphoneManager.h"
#include "src/utils/Misc.h"

#include <bb/cascades/OrientationSupport>

using namespace bb::cascades;

InCallModel::InCallModel(QObject *parent) :
        QObject(parent),
        window_id(NULL),
        window_group(NULL),
        _displayName(""),
        _sipUri(""),
        _callTime(""),
        _photo(""),
        _isVideoEnabled(false),
        _isMicMuted(false),
        _isSpeakerEnabled(false),
        _isPaused(false),
        _currentCallQualityIcon(""),
        _currentCallSecurityIcon(""),
        _areControlsVisible(true),
        _statsTimer(new QTimer(this)),
        _controlsFadeTimer(new QTimer(this)),
        _deviceOrientation(0)
{
    bool result = QObject::connect(LinphoneManager::getInstance(), SIGNAL(callStateChanged(LinphoneCall*)), this, SLOT(callStateChanged(LinphoneCall*)));
    Q_ASSERT(result);

    result = QObject::connect(_statsTimer, SIGNAL(timeout()), this, SLOT(statsTimerTimeout()));
    Q_ASSERT(result);

    result = QObject::connect(_controlsFadeTimer, SIGNAL(timeout()), this, SLOT(fadeTimerTimeout()));
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
    ms_message("[BB10] default device orientation: %s", _deviceOrientation == 0 ? "portrait" : "landscape");
    linphone_core_set_device_rotation(lc, _deviceOrientation);

    _statsTimer->setInterval(1000);
    _controlsFadeTimer->setInterval(30000);

    Q_UNUSED(result);
}

static LinphoneCall* getCurrentCall()
{
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    LinphoneCall *call = linphone_core_get_current_call(lc);
    if (!call) {
        call = (LinphoneCall *) ms_list_nth_data(linphone_core_get_calls(lc), 0);
    }

    return call;
}

void InCallModel::onOrientationAboutToChange(DisplayDirection::Type displayDirection, UIOrientation::Type uiOrientation) {
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();

    if (uiOrientation == UIOrientation::Landscape) {
        _deviceOrientation = displayDirection;
    } else {
        _deviceOrientation = 0;
    }

    ms_message("[BB10] device orientation about to change to %s", _deviceOrientation == 0 ? "portrait" : "landscape");
    linphone_core_set_device_rotation(lc, _deviceOrientation);
    emit deviceOrientationChanged();

    LinphoneCall *call = getCurrentCall();
    if (call) {
        linphone_core_update_call(lc, call, NULL);
    }
}

void InCallModel::statsTimerTimeout()
{
    LinphoneCall *call = getCurrentCall();
    if (!call) {
        return;
    }

    int duration = linphone_call_get_duration(call);
    _callTime = FormatCallDuration(duration);

    float quality = linphone_call_get_current_quality(call);
    if (quality >= 4) {
        _currentCallQualityIcon = "/images/statusbar/call_quality_indicator_4.png";
    } else if (quality >= 3) {
        _currentCallQualityIcon = "/images/statusbar/call_quality_indicator_3.png";
    } else if (quality >= 2) {
        _currentCallQualityIcon = "/images/statusbar/call_quality_indicator_2.png";
    } else if (quality >= 1) {
        _currentCallQualityIcon = "/images/statusbar/call_quality_indicator_1.png";
    } else {
        _currentCallQualityIcon = "/images/statusbar/call_quality_indicator_0.png";
    }

    LinphoneMediaEncryption encryption = linphone_call_params_get_media_encryption(linphone_call_get_current_params(call));
    _currentCallSecurityIcon = "/images/statusbar/security_ko.png";
    if (encryption == LinphoneMediaEncryptionSRTP || encryption == LinphoneMediaEncryptionDTLS) {
        _currentCallSecurityIcon = "/images/statusbar/security_ok.png";
    } else if (encryption == LinphoneMediaEncryptionZRTP) {
        bool isAuthTokenVerified = linphone_call_get_authentication_token_verified(call);
        if (isAuthTokenVerified) {
            _currentCallSecurityIcon = "/images/statusbar/security_ok.png";
        } else {
            _currentCallSecurityIcon = "/images/statusbar/security_pending.png";
        }
    }

    emit statsUpdated();
}

void InCallModel::fadeTimerTimeout()
{
    _areControlsVisible = false;
    emit fadeControlsUpdated();

    _controlsFadeTimer->stop();
}

void InCallModel::resetFadeTimer()
{
    _areControlsVisible = true;
    emit fadeControlsUpdated();

    if (_controlsFadeTimer->isActive()) {
        _controlsFadeTimer->stop();
    }
    _controlsFadeTimer->start();
}

void InCallModel::switchFullScreenMode()
{
    if (_areControlsVisible) {
        _controlsFadeTimer->stop();
    } else {
        if (_controlsFadeTimer->isActive()) {
            _controlsFadeTimer->stop();
        }
        _controlsFadeTimer->start();
    }
    _areControlsVisible = !_areControlsVisible;
    emit fadeControlsUpdated();
}

void InCallModel::onVideoSurfaceCreationCompleted(QString id, QString group)
{
    window_group = QStringToChar(group);
    window_id = QStringToChar(id);

    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    linphone_core_set_native_video_window_id(lc, (void*) window_group);
    linphone_core_set_native_preview_window_id(lc, (void*) window_group);
    ms_message("[BB10] Video window id: %s and group %s", window_id, window_group);
}

void InCallModel::callStateChanged(LinphoneCall *call) {
    if (!call) {
        call = getCurrentCall();
    }
    if (!call) {
        return;
    }

    LinphoneCallState state = linphone_call_get_state(call);
    _isPaused = state == LinphoneCallPaused;

    if (state == LinphoneCallIncomingReceived || state == LinphoneCallOutgoingInit) {
        if (!_statsTimer->isActive()) {
            _statsTimer->start();
        }

        const LinphoneAddress *addr = linphone_call_get_remote_address(call);
        ContactFound contact = ContactFetcher::getInstance()->findContact(linphone_address_get_username(addr));
        if (contact.id >= 0) {
            _displayName = contact.displayName;
            _photo = contact.picturePath;
        } else {
            _displayName = GetDisplayNameFromLinphoneAddress(addr);
            _photo = "/images/avatar.png";
        }
        _sipUri = linphone_address_as_string_uri_only(addr);
    } else if (state == LinphoneCallEnd || state == LinphoneCallError) {
        if (_statsTimer->isActive()) {
            _statsTimer->stop();
        }
        if (_controlsFadeTimer->isActive()) {
            _controlsFadeTimer->stop();
        }

        _isSpeakerEnabled = false;
        _isMicMuted = false;
        _isPaused = false;
        _isVideoEnabled = false;
    } else if (state == LinphoneCallStreamsRunning) {
        if (_isVideoEnabled) {
            if (!_controlsFadeTimer->isActive()) {
                _controlsFadeTimer->start();
            }
        } else {
            if (_controlsFadeTimer->isActive())
                _controlsFadeTimer->stop();
        }
    }

    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();

    const LinphoneCallParams *params = linphone_call_get_current_params(call);
    setVideoEnabled(linphone_call_params_video_enabled(params));
    setMicMuted(linphone_core_is_mic_muted(lc));

    emit callUpdated();
}

void InCallModel::accept() {
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    LinphoneCall *call = getCurrentCall();
    if (call) {
        linphone_core_accept_call(lc, call);
    }
}

void InCallModel::hangUp()
{
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    LinphoneCall *call = getCurrentCall();
    if (call) {
        linphone_core_terminate_call(lc, call);
    }
}

void InCallModel::setVideoEnabled(const bool &enabled)
{
    if (enabled == _isVideoEnabled) {
        return;
    }

    _isVideoEnabled = enabled;

    if (_isVideoEnabled) {
        resetFadeTimer();
    } else {
        _areControlsVisible = true;
        emit fadeControlsUpdated();

        if (_controlsFadeTimer->isActive()) {
            _controlsFadeTimer->stop();
        }
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
        linphone_call_params_enable_video(params, enabled);
        linphone_core_update_call(lc, call, params);
    }

    emit callUpdated();
}

void InCallModel::setMicMuted(const bool &muted)
{
    if (muted == _isMicMuted) {
        return;
    }

    _isMicMuted = muted;

    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    linphone_core_mute_mic(lc, muted);

    emit callUpdated();
}

void InCallModel::setSpeakerEnabled(const bool &enabled)
{
    if (enabled == _isSpeakerEnabled) {
        return;
    }

    LinphoneCall *call = getCurrentCall();
    if (call) {
        _isSpeakerEnabled = enabled;
        MSAudioRoute route = _isSpeakerEnabled ? MSAudioRouteSpeaker : MSAudioRouteEarpiece;
        linphone_call_set_audio_route(call, route);
        emit callUpdated();
    }
}

void InCallModel::switchCamera()
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

void InCallModel::togglePause()
{
    LinphoneCall *call = getCurrentCall();
    if (!call) {
        return;
    }

    LinphoneCallState state = linphone_call_get_state(call);
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    if (lc) {
        if (state == LinphoneCallPaused) {
            linphone_core_resume_call(lc, call);
        } else if (state == LinphoneCallStreamsRunning || state == LinphoneCallPausedByRemote) {
            linphone_core_pause_call(lc, call);
        }
    }
}

bool InCallModel::isInCall() const {
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    return linphone_core_get_calls_nb(lc) > 0;
}
