/*
 * LinphoneManager.cpp
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
 *  Created on: 15 févr. 2015
 *      Author: Sylvain Berfini
 */

#include <qdir.h>
#include <unistd.h>

#include <bb/cascades/QmlDocument>
#include <bb/cascades/Page>
#include <bb/cascades/Application>
#include <bb/device/HardwareInfo>

#include "LinphoneManager.h"
#include "src/utils/Misc.h"

using namespace bb::cascades;
using namespace bb::device;

LinphoneManager::LinphoneManager(bb::Application *app)
    : QObject(app),
      _app(app),
      _lc(NULL),
      _iterate_enabled(FALSE),
      _iterate_timer(NULL),
      _isAppInBackground(FALSE),
      _notificationManager(new NotificationManager(app)),
      _unreadChatMessages(0),
      _unreadMissedCalls(0)
{
    bool result = QObject::connect(_app, SIGNAL(manualExit()), this, SLOT(onAppExit()));
    Q_ASSERT(result);

    result = QObject::connect(_app, SIGNAL(fullscreen()), this, SLOT(onAppFullscreen()));
    Q_ASSERT(result);

    result = QObject::connect(_app, SIGNAL(thumbnail()), this, SLOT(onAppThumbnail()));
    Q_ASSERT(result);
    Q_UNUSED(result);

    _app->setAutoExit(false);
}

LinphoneManager* LinphoneManager::createInstance(bb::Application *app)
{
    if (!_linphoneManagerInstance)
        _linphoneManagerInstance = new LinphoneManager(app);

    return _linphoneManagerInstance;
}

LinphoneManager* LinphoneManager::getInstance()
{
    return _linphoneManagerInstance;
}

LinphoneCore* LinphoneManager::getLc()
{
    return _lc;
}

void LinphoneManager::call(QString sipUri) {
    LinphoneAddress *addr = linphone_core_interpret_url(_lc, sipUri.toUtf8().constData());
    if (addr) {
        linphone_core_invite_address(_lc, addr);
    }
}

void LinphoneManager::transferCall(QString toSipUri) {
    LinphoneCall *call = linphone_core_get_current_call(_lc);
    if (call) {
        linphone_core_transfer_call(_lc, call, toSipUri.toUtf8().constData());
    }
}

void LinphoneManager::refreshRegisters() {
    linphone_core_refresh_registers(_lc);
}

void LinphoneManager::onAppFullscreen()
{
    // Called only when app is returning to fullscreen mode after being thumbnailed or other.
    _isAppInBackground = false;
    linphone_core_refresh_registers(_lc);

    _app->setIconBadge(bb::IconBadge::None);
}

void LinphoneManager::onAppThumbnail()
{
    _isAppInBackground = true;
}

void LinphoneManager::onAppExit()
{
    // We have less than 3 seconds to clean up resources, else we'd have to call extendTerminationTimeout() to get 2 seconds more.
    destroy();
    _app->quit();
}

static void global_state_changed(LinphoneCore *lc, LinphoneGlobalState state, const char *msg)
{
    ms_message("[BB10] Global state changed: %s", msg);

    Q_UNUSED(lc);
    Q_UNUSED(state);
}

void LinphoneManager::onRegistrationStatusChanged(LinphoneProxyConfig *cfg, LinphoneRegistrationState state)
{
    if (!cfg) {
        return;
    }

    LinphoneCore *lc = linphone_proxy_config_get_core(cfg);
    LinphoneProxyConfig *defaultLpc = linphone_core_get_default_proxy_config(lc);
    if (!AreProxyConfigsTheSame(defaultLpc, cfg)) {
        return;
    }

    switch (state) {
        case LinphoneRegistrationOk:
            _registrationStatusImage = "/images/statusbar/led_connected.png";
            _registrationStatusText = tr("registered");
            break;
        case LinphoneRegistrationProgress:
            _registrationStatusImage = "/images/statusbar/led_inprogress.png";
            _registrationStatusText = tr("in progress");
            break;
        case LinphoneRegistrationFailed:
            _registrationStatusImage = "/images/statusbar/led_error.png";
            _registrationStatusText = tr("error");
            break;
        default:
            _registrationStatusImage = "/images/statusbar/led_disconnected.png";
            _registrationStatusText = tr("disconnected");
            break;
    }
    emit registrationStatusChanged(state);
}

static void registration_state_changed(LinphoneCore *lc, LinphoneProxyConfig *cfg, LinphoneRegistrationState state, const char *msg)
{
    ms_message("[BB10] Registration state changed: %s", msg);

    LinphoneManager *manager = (LinphoneManager *)linphone_core_get_user_data(lc);
    manager->onRegistrationStatusChanged(cfg, state);
}

void LinphoneManager::onCallStateChanged(LinphoneCall *call, LinphoneCallState state) {
    if (state == LinphoneCallIncomingReceived) {
        emit incomingCallReceived(call);

        if (_isAppInBackground) {
            _notificationManager->notifyIncomingCall(call);
        }
    } else if (state == LinphoneCallOutgoingInit) {
        emit outgoingCallInit(call);
    } else if (state == LinphoneCallConnected) {
        emit callConnected(call);
    } else if (state == LinphoneCallEnd || state == LinphoneCallError) {
        emit callEnded(call);

        if (_isAppInBackground) {
            _notificationManager->dismissIncomingCallNotification();
        }

        _unreadMissedCalls = linphone_core_get_missed_calls_count(_lc);
        emit onUnreadCountUpdated();
        updateAppIconBadge();
    }
    emit callStateChanged(call);
}

static void call_state_changed(LinphoneCore *lc, LinphoneCall *call, LinphoneCallState state, const char *msg)
{
    ms_message("[BB10] Call state changed: %s", msg);

    LinphoneManager *manager = LinphoneManager::getInstance();
    manager->onCallStateChanged(call, state);

    Q_UNUSED(lc);
}

void LinphoneManager::onMessageReceived(LinphoneChatRoom *room, LinphoneChatMessage *message)
{
    emit messageReceived(room, message);

    if (_isAppInBackground) {
        _notificationManager->notifyIncomingMessage(message);
    }

    updateUnreadChatMessagesCount();
}

static void message_received(LinphoneCore *lc, LinphoneChatRoom *room, LinphoneChatMessage *message)
{
    LinphoneManager *manager = (LinphoneManager *)linphone_core_get_user_data(lc);
    manager->onMessageReceived(room, message);

    Q_UNUSED(lc);
    Q_UNUSED(room);
    Q_UNUSED(message);
}

void LinphoneManager::onComposingReceived(LinphoneChatRoom *room)
{
    emit composingReceived(room);
}

static void composing_received(LinphoneCore *lc, LinphoneChatRoom *room)
{
    LinphoneManager *manager = (LinphoneManager *)linphone_core_get_user_data(lc);
    manager->onComposingReceived(room);

    Q_UNUSED(lc);
    Q_UNUSED(room);
}

QString LinphoneManager::moveLinphoneRcToRWFolder()
{
    QString dataFolder = QDir::homePath();
    QString rcPath = dataFolder + "/linphonerc";
    QFile rcFile(rcPath);
    if (!rcFile.exists()) {
        QString originalRcPath = "app/native/assets/linphone/linphonerc";
        QFile originalRcFile(originalRcPath);
        if (originalRcFile.exists()) {
            originalRcFile.copy(rcPath);
        }
    }
    return rcPath;
}

void LinphoneManager::onIterateTrigger()
{
    if(_iterate_enabled) {
        linphone_core_iterate(_lc);
    }
}

void LinphoneManager::startLinphoneCoreIterate()
{
    _iterate_enabled = TRUE;

    _iterate_timer = new QTimer(this);
    _iterate_timer->setInterval(20);
    QObject::connect(_iterate_timer, SIGNAL(timeout()), this, SLOT(onIterateTrigger()));
    _iterate_timer->start();
}

void LinphoneManager::createAndStartLinphoneCore()
{
    char* linphoneRC = strdup(moveLinphoneRcToRWFolder().toUtf8().data());
    LpConfig *lpc = lp_config_new(linphoneRC);

    QString logsPath = QDir::homePath() + "/logs/";
    linphone_core_set_log_collection_path(logsPath.toUtf8().constData());
    if (lp_config_get_int(lpc, "app", "log_collection", 0) == 1) {
        linphone_core_enable_log_collection(LinphoneLogCollectionEnabled);
    }

    bool debugEnabled = lp_config_get_int(lpc, "app", "debug", 0) == 1;
    OrtpLogLevel logLevel = static_cast<OrtpLogLevel>(ORTP_LOGLEV_END);
    if (debugEnabled) {
        logLevel = static_cast<OrtpLogLevel>(ORTP_MESSAGE | ORTP_WARNING | ORTP_FATAL | ORTP_ERROR);
    }
    linphone_core_set_log_level_mask(logLevel);

    LinphoneCoreVTable *vtable = (LinphoneCoreVTable*) malloc(sizeof(LinphoneCoreVTable));
    memset (vtable, 0, sizeof(LinphoneCoreVTable));
    vtable->global_state_changed = global_state_changed;
    vtable->registration_state_changed = registration_state_changed;
    vtable->call_state_changed = call_state_changed;
    vtable->message_received = message_received;
    vtable->is_composing_received = composing_received;

    _lc = linphone_core_new(vtable, linphoneRC, "app/native/assets/linphone/factory", this);

    linphone_core_migrate_to_multi_transport(_lc);
    linphone_core_set_user_agent(_lc, "Linphone BB10", _app->applicationVersion().toUtf8().constData());
    linphone_core_set_network_reachable(_lc, true);

    const HardwareInfo hi;
    ms_set_cpu_count(hi.processorCount());

    linphone_core_set_ring(_lc, "app/native/assets/sounds/oldphone_mono.wav");

    QString chatMessagesDatabase = QDir::homePath() + "/chat.db";
    linphone_core_set_chat_database_path(_lc, strdup(chatMessagesDatabase.toUtf8().constData()));
    QString historyLogsDatabase = QDir::homePath() + "/history.db";
    linphone_core_set_call_logs_database_path(_lc, strdup(historyLogsDatabase.toUtf8().constData()));

    QString zrtpCache = QDir::homePath() + "/zrtp_secrets";
    linphone_core_set_zrtp_secrets_file(_lc, strdup(zrtpCache.toUtf8().constData()));

    updateUnreadChatMessagesCount();
    startLinphoneCoreIterate();
}

static void countUnreadChatMessages(void *item, void *user_data)
{
    LinphoneManager *manager = (LinphoneManager *)user_data;
    LinphoneChatRoom *room = (LinphoneChatRoom *)item;
    if (room == NULL || manager == NULL)
        return;

    int currentCount = manager->unreadChatMessages();
    currentCount += linphone_chat_room_get_unread_messages_count(room);
    manager->setUnreadChatMessages(currentCount);
}

void LinphoneManager::updateUnreadChatMessagesCount()
{
    _unreadChatMessages = 0;
    const MSList *rooms = linphone_core_get_chat_rooms(_lc);
    ms_list_for_each2(rooms, countUnreadChatMessages, this);
    emit onUnreadCountUpdated();
    updateAppIconBadge();
}

void LinphoneManager::resetUnreadMissedCallsCount()
{
    linphone_core_reset_missed_calls_count(_lc);
    _unreadMissedCalls = 0;
    emit onUnreadCountUpdated();
    updateAppIconBadge();
}

void LinphoneManager::updateAppIconBadge()
{
    if (_unreadChatMessages > 0 || _unreadMissedCalls > 0) {
        _app->setIconBadge(bb::IconBadge::Splat);
    } else {
        _app->setIconBadge(bb::IconBadge::None);
    }
}

void LinphoneManager::playDtmf(QString character)
{
    if (_lc) {
        linphone_core_play_dtmf(_lc, character.at(0).toAscii(), -1);
    }
}

void LinphoneManager::stopDtmf()
{
    if (_lc) {
        linphone_core_stop_dtmf(_lc);
    }
}

void LinphoneManager::destroy()
{
    ms_message("[BB10] Stopping iterate");
    _iterate_enabled = FALSE;
    _iterate_timer->stop();

    ms_message("[BB10] Destroying core");
    linphone_core_destroy(_lc);
}

void LinphoneManager::exit() {
    _app->exit(0);
}

void LinphoneManager::firstLaunchSuccessful() {
    if (!_lc)
        return;

    LpConfig *conf = linphone_core_get_config(_lc);
    lp_config_set_int(conf, "app", "first_start_successful", 1);
}

bool LinphoneManager::shouldStartWizardWhenAppStarts() {
    if (!_lc)
        return false;

    LpConfig *conf = linphone_core_get_config(_lc);
    return lp_config_get_int(conf, "app", "first_start_successful", 0) == 0;
}
