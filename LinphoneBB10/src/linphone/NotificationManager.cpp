/*
 * NotificationManager.cpp
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
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 *
 *  Created on: 4 août 2015
 *      Author: Sylvain Berfini
 */

#include "NotificationManager.h"
#include "src/contacts/ContactFetcher.h"
#include "src/utils/Misc.h"
#include "LinphoneManager.h"

using namespace bb::platform;
using namespace bb::system;

NotificationManager::NotificationManager(bb::Application *app)
    : _app(app),
      _incomingCallNotification(NULL),
      _incomingCallNotificationAnswerButton(NULL),
      _incomingCallNotificationDeclineButton(NULL)
{

}

void NotificationManager::notifyIncomingCall(LinphoneCall *call)
{
    QString displayName;

    const LinphoneAddress *addr = linphone_call_get_remote_address(call);
    ContactFound contact = ContactFetcher::getInstance()->findContact(linphone_address_get_display_name(addr));
    if (contact.id >= 0) {
        displayName = contact.displayName;
    } else {
        displayName = GetDisplayNameFromLinphoneAddress(addr);
    }
    QString sipUri = GetAddressFromLinphoneAddress(addr);

    InvokeRequest invokeRequest;
    invokeRequest.setTarget("org.linphone.invoke");
    invokeRequest.setAction("bb.action.OPEN");
    invokeRequest.setMimeType("application/vnd.linphone");
    _incomingCallNotificationAnswerButton = new SystemUiButton(QObject::tr("Answer call"));
    _incomingCallNotificationDeclineButton = new SystemUiButton(QObject::tr("Decline call"));

    _incomingCallNotification = new NotificationDialog();
    _incomingCallNotification->setTitle(QObject::tr("Incoming call from ") + displayName);
    _incomingCallNotification->setBody(sipUri);
    //_incomingCallNotification->setRepeat(true);
    _incomingCallNotification->appendButton(_incomingCallNotificationAnswerButton, invokeRequest);
    _incomingCallNotification->appendButton(_incomingCallNotificationDeclineButton);
    _incomingCallNotification->appendButton(new SystemUiButton(QObject::tr("Ignore call")));
    bool success = QObject::connect(_incomingCallNotification, SIGNAL(finished(bb::platform::NotificationResult::Type)), this, SLOT(onIncomingCallDialogButtonSelected(bb::platform::NotificationResult::Type)));
    if (success) {
        _incomingCallNotification->show();
    }
}

void NotificationManager::dismissIncomingCallNotification()
{
    if (_incomingCallNotification) {
        _incomingCallNotification->cancel();
    }
}

void NotificationManager::onIncomingCallDialogButtonSelected(NotificationResult::Type result)
{
    if (result == NotificationResult::ButtonSelection) {
        SystemUiButton *button = _incomingCallNotification->buttonSelection();

        LinphoneManager *manager = LinphoneManager::getInstance();
        LinphoneCore *lc = manager->getLc();
        LinphoneCall *call = linphone_core_get_current_call(lc);
        if (!call) {
            call = (LinphoneCall *) ms_list_nth_data(linphone_core_get_calls(lc), 0);
        }

        if (call) {
            if (button == _incomingCallNotificationAnswerButton) {
                linphone_core_accept_call(lc, call);
            } else if (button == _incomingCallNotificationDeclineButton) {
                linphone_core_terminate_call(lc, call);
            }
        }
    }
}

void NotificationManager::notifyIncomingMessage(LinphoneChatMessage *message)
{
    if (!message) {
        return;
    }

    Notification notification;

    const char *text = linphone_chat_message_get_text(message);
    notification.setBody(QString::fromUtf8(text));

    const LinphoneAddress *addr = linphone_chat_message_get_peer_address(message);
    ContactFound contact = ContactFetcher::getInstance()->findContact(linphone_address_get_username(addr));
    if (contact.id >= 0) {
        notification.setTitle(contact.displayName);
    } else {
        notification.setTitle(GetDisplayNameFromLinphoneAddress(addr));
    }
    notification.setIconUrl(QUrl("app/public/chat_message_notification_icon.png"));

    InvokeRequest request;
    request.setTarget("org.linphone.invoke");
    request.setMimeType("application/vnd.linphone");
    notification.setInvokeRequest(request);

    notification.notify();
}
