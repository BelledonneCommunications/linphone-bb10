/*
 * ChatListModel.h
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

#ifndef CHATLISTMODEL_H_
#define CHATLISTMODEL_H_

#include <bb/cascades/GroupDataModel>
#include <QObject>

#include "ChatFetcher.h"
#include "ChatModel.h"
#include "src/utils/ListEditorHelper.h"

class ChatListModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(ListEditorHelper* editor READ editor CONSTANT);
    Q_PROPERTY(ChatModel* chatModel READ chatModel CONSTANT);
    Q_PROPERTY(bb::cascades::GroupDataModel* dataModel READ dataModel NOTIFY chatListUpdated)

public:
    ChatListModel(QObject *parent = NULL);

public Q_SLOTS:
    void getChatList();
    void updateChatList(LinphoneChatRoom *room, LinphoneChatMessage *message);
    void updateChatUnreadCount(QString sipAddress);
    void viewConversation(const QVariantList &indexPath);
    void viewConversation(QString sipUri);
    void newConversation();
    void chatFetched(QVariantMap chat);
    void deleteItems(QList<QVariantList> indexPaths);

Q_SIGNALS:
    void chatListUpdated();

private:
    ChatFetcher *_chatFetcher;

    bb::cascades::GroupDataModel* dataModel() const {
        return _dataModel;
    }
    bb::cascades::GroupDataModel* _dataModel;

    ListEditorHelper *editor() const {
        return _listEditorHelper;
    }
    ListEditorHelper *_listEditorHelper;

    ChatModel *chatModel() const {
        return _chatModel;
    }
    ChatModel *_chatModel;

    QString _selectedConversationSipAddress;
};

#endif /* CHATLISTMODEL_H_ */
