/*
 * NotificationManager.h
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
 *  Created on: 4 août 2015
 *      Author: Sylvain Berfini
 */

#ifndef NOTIFICATIONMANAGER_H_
#define NOTIFICATIONMANAGER_H_

#include "linphone/linphonecore.h"

#include <bb/Application>
#include <bb/platform/Notification>
#include <bb/system/InvokeRequest>
#include <bb/platform/NotificationDialog.hpp>
#include <bb/platform/NotificationResult>
#include <bb/system/SystemUiButton.hpp>

class NotificationManager : public QObject
{
    Q_OBJECT

public:
    NotificationManager(bb::Application *app);
    void notifyIncomingCall(LinphoneCall *call);
    void dismissIncomingCallNotification();
    void notifyIncomingMessage(LinphoneChatMessage *message);

public Q_SLOTS:
    void onIncomingCallDialogButtonSelected(bb::platform::NotificationResult::Type result);

private:
    bb::Application *_app;
    bb::platform::NotificationDialog *_incomingCallNotification;
    bb::system::SystemUiButton *_incomingCallNotificationAnswerButton;
    bb::system::SystemUiButton *_incomingCallNotificationDeclineButton;
};

#endif /* NOTIFICATIONMANAGER_H_ */
