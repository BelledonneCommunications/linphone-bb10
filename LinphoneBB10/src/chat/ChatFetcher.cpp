/*
 * ChatFetcher.cpp
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
 *  Created on: 2 août 2015
 *      Author: Sylvain Berfini
 */

#include "ChatFetcher.h"
#include "src/contacts/ContactFetcher.h"
#include "src/linphone/LinphoneManager.h"
#include "src/utils/Misc.h"

using namespace bb::cascades;

ChatFetcher::ChatFetcher()
{

}

static QVariantMap fillEntry(LinphoneChatRoom *room, LinphoneChatMessage *lastMessage, QVariantMap entry) {
    const LinphoneAddress *address = linphone_chat_room_get_peer_address(room);
    entry["linphoneAddress"] = linphone_address_as_string_uri_only(address);

    const char *displayName = GetDisplayNameFromLinphoneAddress(address);
    entry["displayName"] = displayName;
    entry["contactPhoto"] = "/images/avatar.png";

    ContactFound cf = ContactFetcher::getInstance()->findContact(linphone_address_get_username(address));
    if (cf.id >= 0) {
        entry["displayName"] = cf.displayName;
        entry["contactPhoto"] = cf.smallPicturePath;
    }

    const char *text = linphone_chat_message_get_text(lastMessage);
    entry["text"] = QString::fromUtf8(text);

    const LinphoneContent *content = linphone_chat_message_get_file_transfer_information(lastMessage);
    const char *external_body_url = linphone_chat_message_get_external_body_url(lastMessage);
    bool isFileTransfer = content || external_body_url;
    entry["isFileTransferMessage"] = isFileTransfer;
    if (isFileTransfer) {
        entry["text"] = "";
        entry["imageSource"] = "/images/chat/image_received.png";
    }

    time_t time = linphone_chat_message_get_time(lastMessage);
    entry["time"] = time;
    QString lastMessageTime = FormatDateForChat(time);
    if (lastMessageTime.length() == 0) {
        lastMessageTime = GetTime(time);
    }
    entry["displayTime"] = lastMessageTime;

    entry["unreadCount"] = linphone_chat_room_get_unread_messages_count(room);
    entry["selected"] = false;

    return entry;
}

static void addChatRoomToListModel(void *item, void *user_data)
{
    ChatFetcher *model = (ChatFetcher *)user_data;
    LinphoneChatRoom *room = (LinphoneChatRoom *)item;
    if (room == NULL || model == NULL)
        return;

    QVariantMap entry;
    if (linphone_chat_room_get_history_size(room) > 0) {
        MSList *history = linphone_chat_room_get_history(room, 1);
        LinphoneChatMessage *lastMessage = (LinphoneChatMessage *)ms_list_nth_data(history, 0);
        if (lastMessage) {
            entry = fillEntry(room, lastMessage, entry);
            emit model->emitChatFetched(entry);
        }
    }
}

void ChatFetcher::run()
{
    LinphoneManager *manager = LinphoneManager::getInstance();
    if (manager) {
        LinphoneCore *lc = manager->getLc();
        if (lc) {
            const MSList* rooms = linphone_core_get_chat_rooms(lc);
            ms_list_for_each2(rooms, addChatRoomToListModel, this);
        }
    }
}

void ChatFetcher::updateChat(LinphoneChatRoom *room, LinphoneChatMessage *message, GroupDataModel *dataModel)
{
    const LinphoneAddress *address = linphone_chat_room_get_peer_address(room);
    QString sipAddress = linphone_address_as_string_uri_only(address);

    foreach (QVariantMap entry, dataModel->toListOfMaps()) {
        QString addr = entry.value("linphoneAddress").toString();
        if (QString::compare(addr, sipAddress) == 0) {
            QVariantList indexPath = dataModel->findExact(entry);
            if (message != NULL) {
                entry = fillEntry(room, message, entry);
                dataModel->updateItem(indexPath, entry);
            } else {
                linphone_chat_room_destroy(room);
                dataModel->removeAt(indexPath);
            }
            return;
        }
    }

    if (message) {
        QVariantMap entry;
        entry = fillEntry(room, message, entry);
        QVariantList emptyIndexPath;
        dataModel->insert(entry);
    }
}

void ChatFetcher::updateChatReadCount(QString sipAddress, GroupDataModel *dataModel)
{
    foreach (QVariantMap entry, dataModel->toListOfMaps()) {
        QString addr = entry.value("linphoneAddress").toString();
        if (QString::compare(addr, sipAddress) == 0) {
            QVariantList indexPath = dataModel->findExact(entry);
            entry["unreadCount"] = 0;
            dataModel->updateItem(indexPath, entry);
            return;
        }
    }
}

void ChatFetcher::emitChatFetched(QVariantMap chat)
{
    emit chatFetched(chat);
}
