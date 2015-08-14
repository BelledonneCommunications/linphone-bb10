/*
 * ChatListModel.cpp
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
 *  Created on: 20 févr. 2015
 *      Author: Sylvain Berfini
 */

#include "ChatListModel.h"
#include "src/contacts/ContactFetcher.h"
#include "src/linphone/LinphoneManager.h"
#include "src/utils/Misc.h"

using namespace bb::cascades;

ChatListModel::ChatListModel(QObject *parent)
    : QObject(parent),
      _chatFetcher(new ChatFetcher()),
      _dataModel(new GroupDataModel(this)),
      _listEditorHelper(new ListEditorHelper(_dataModel)),
      _chatModel(new ChatModel(this)),
      _selectedConversationSipAddress("")
{
    _dataModel->setGrouping(ItemGrouping::None);
    QStringList sortingKeys;
    sortingKeys << "time";
    _dataModel->setSortingKeys(sortingKeys);
    _dataModel->setSortedAscending(false);

    LinphoneManager *manager = LinphoneManager::getInstance();
    bool result = QObject::connect(manager, SIGNAL(messageReceived(LinphoneChatRoom*, LinphoneChatMessage*)), this, SLOT(updateChatList(LinphoneChatRoom*, LinphoneChatMessage*)));
    Q_ASSERT(result);
    result = QObject::connect(_chatModel, SIGNAL(messageSent(LinphoneChatRoom*, LinphoneChatMessage*)), this, SLOT(updateChatList(LinphoneChatRoom*, LinphoneChatMessage*)));
    Q_ASSERT(result);
    result = QObject::connect(_chatModel, SIGNAL(messagesRead(QString)), this, SLOT(updateChatUnreadCount(QString)));
    Q_ASSERT(result);
    result = QObject::connect(_chatModel, SIGNAL(messagesDeleted(LinphoneChatRoom*, LinphoneChatMessage*)), this, SLOT(updateChatList(LinphoneChatRoom*, LinphoneChatMessage*)));
    Q_ASSERT(result);

    result = connect(_chatFetcher, SIGNAL(chatFetched(QVariantMap)), this, SLOT(chatFetched(QVariantMap)));
    Q_ASSERT(result);

    result = connect(_listEditorHelper, SIGNAL(deleteRequested(QList<QVariantList>)), this, SLOT(deleteItems(QList<QVariantList>)));
    Q_ASSERT(result);

    getChatList();
}

void ChatListModel::viewConversation(const QVariantList &indexPath)
{
    QString sipUri = "";
    if (!indexPath.isEmpty()) {
        const QVariantMap entry = _dataModel->data(indexPath).toMap();
        sipUri = entry.value("linphoneAddress").toString();
    }

    viewConversation(sipUri);
}

void ChatListModel::viewConversation(QString sipUri)
{
    _selectedConversationSipAddress = sipUri;

    if (_chatModel == NULL)
        return;

    _chatModel->setSelectedConversationSipAddress(sipUri);
}

void ChatListModel::newConversation()
{
    _selectedConversationSipAddress = "";

    if (_chatModel == NULL)
        return;

    _chatModel->setSelectedConversationSipAddress("");
}


void ChatListModel::getChatList()
{
    if (_chatFetcher) {
        if (_chatFetcher->isRunning()) {
            _chatFetcher->exit();
        }

        if (_dataModel) {
            _dataModel->clear();
        }

        _chatFetcher->start(QThread::HighPriority);
    }
}

void ChatListModel::chatFetched(QVariantMap entry)
{
    if (_dataModel == NULL) {
        return;
    }

    _dataModel->insert(entry);
    emit chatListUpdated();
}

void ChatListModel::updateChatList(LinphoneChatRoom *room, LinphoneChatMessage *message)
{
    if (_chatFetcher && _dataModel) {
        _chatFetcher->updateChat(room, message, _dataModel);
    }
    emit chatListUpdated();
}

void ChatListModel::updateChatUnreadCount(QString sipAddress)
{
    if (_chatFetcher && _dataModel) {
        _chatFetcher->updateChatReadCount(sipAddress, _dataModel);
    }
    emit chatListUpdated();
}

void ChatListModel::deleteItems(QList<QVariantList> indexPaths)
{
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();

    foreach(QVariantList indexPath, indexPaths) {
        QVariantMap entry = _dataModel->data(indexPath).toMap();
        QString addr = entry.value("linphoneAddress").toString();

        if (addr.length() == 0) {
            continue;
        }

        LinphoneChatRoom *room = linphone_core_get_or_create_chat_room(lc, addr.toUtf8().constData());
        linphone_chat_room_delete_history(room);
        linphone_chat_room_destroy(room);

        _dataModel->removeAt(indexPath);
    }

    emit chatListUpdated();
}
