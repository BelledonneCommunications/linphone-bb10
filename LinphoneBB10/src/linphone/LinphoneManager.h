/*
 * LinphoneManager.h
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

#ifndef LINPHONEMANAGER_H_
#define LINPHONEMANAGER_H_

#include <bb/Application>
#include <QtCore/QObject>
#include <QtCore/QTimer>
#include <bb/PackageInfo>

#include "NotificationManager.h"
#include "linphone/linphonecore.h"

class LinphoneManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString registrationStatusImage READ registrationStatusImage NOTIFY registrationStatusChanged);
    Q_PROPERTY(QString registrationStatusText READ registrationStatusText NOTIFY registrationStatusChanged);
    Q_PROPERTY(int unreadChatMessages READ unreadChatMessages NOTIFY onUnreadCountUpdated);
    Q_PROPERTY(int unreadMissedCalls READ unreadMissedCalls NOTIFY onUnreadCountUpdated);
    Q_PROPERTY(QString coreVersion READ coreVersion);
    Q_PROPERTY(QString appVersion READ appVersion);
    Q_PROPERTY(QString blackberryVersion READ blackberryVersion);

public:
    static LinphoneManager* createInstance(bb::Application *app);
    static LinphoneManager* getInstance();
    void createAndStartLinphoneCore();
    void destroy();
    LinphoneCore* getLc();
    void onMessageReceived(LinphoneChatRoom *room, LinphoneChatMessage *message);
    void onRegistrationStatusChanged(LinphoneProxyConfig *cfg, LinphoneRegistrationState status);
    void onComposingReceived(LinphoneChatRoom *room);
    void onCallStateChanged(LinphoneCall *call, LinphoneCallState state);

    int unreadChatMessages() const {
        return _unreadChatMessages;
    }
    void setUnreadChatMessages(int count) {
        _unreadChatMessages = count;
    }

    int unreadMissedCalls() const {
        return _unreadMissedCalls;
    }
    void setUnreadMissedCalls(int count) {
        _unreadMissedCalls = count;
    }

public Q_SLOTS:
    void call(QString sipUri);
    void refreshRegisters();
    void updateUnreadChatMessagesCount();
    void resetUnreadMissedCallsCount();
    void playDtmf(QString character);
    void stopDtmf();
    void exit();

Q_SIGNALS:
    void messageReceived(LinphoneChatRoom *room, LinphoneChatMessage *message);
    void registrationStatusChanged(LinphoneRegistrationState status);
    void composingReceived(LinphoneChatRoom *room);
    void incomingCallReceived(LinphoneCall *call);
    void outgoingCallInit(LinphoneCall *call);
    void callEnded(LinphoneCall *call);
    void callConnected(LinphoneCall *call);
    void callStateChanged(LinphoneCall *call);
    void onUnreadCountUpdated();

private Q_SLOTS:
    void onAppExit();
    void onAppFullscreen();
    void onAppThumbnail();
    void onIterateTrigger();

private:
    LinphoneManager(bb::Application *app);
    QString moveLinphoneRcToRWFolder();
    void startLinphoneCoreIterate();
    void notifyIncomingCall(LinphoneCall *call);
    void notifyIncomingMessage(LinphoneChatMessage *message);
    void clearNotifications();
    void updateAppIconBadge();

    bb::Application *_app;
    LinphoneCore *_lc;
    bool_t _iterate_enabled;
    QTimer *_iterate_timer;
    bool _isAppInBackground;
    NotificationManager *_notificationManager;

    QString registrationStatusImage() const {
        return _registrationStatusImage;
    }
    QString _registrationStatusImage;

    QString registrationStatusText() const {
        return _registrationStatusText;
    }
    QString _registrationStatusText;

    int _unreadChatMessages;
    int _unreadMissedCalls;

    QString appVersion() const {
        QString version = QT_TR_NOOP("Linphone %%s");
        return version.replace("%%s", _app->applicationVersion());
    }

    QString coreVersion() const {
        QString version = QT_TR_NOOP("LinphoneCore %%s");
        return version.replace("%%s", linphone_core_get_version());
    }

    QString blackberryVersion() const {
        bb::PackageInfo packageInfo;
        QString version = QT_TR_NOOP("Blackberry OS %%s");
        return version.replace("%%s", packageInfo.systemDependency());
    }
};

static LinphoneManager *_linphoneManagerInstance = NULL;

#endif /* LINPHONEMANAGER_H_ */
