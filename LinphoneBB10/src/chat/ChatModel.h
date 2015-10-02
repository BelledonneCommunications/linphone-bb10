/*
 * ChatModel.h
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

#ifndef CHATMODEL_H_
#define CHATMODEL_H_

#include <QObject>
#include <bb/cascades/GroupDataModel>
#include <bb/cascades/ImageView>

#include "src/contacts/ContactFetcher.h"
#include "src/utils/ListEditorHelper.h"
#include "linphone/linphonecore.h"

// Needed to be able to store the message in the QVariant map
Q_DECLARE_METATYPE(LinphoneChatMessage*);

class ChatModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString displayName READ displayName NOTIFY remoteChateeChanged);
    Q_PROPERTY(QString linphoneAddress READ linphoneAddress NOTIFY remoteChateeChanged);
    Q_PROPERTY(bb::cascades::GroupDataModel* dataModel READ dataModel NOTIFY messageHistoryChanged);
    Q_PROPERTY(bool isNewConversation READ isNewConversation WRITE setNewConversation NOTIFY remoteChateeChanged);
    Q_PROPERTY(bool isUploadInProgress READ isUploadInProgress NOTIFY uploadProgressChanged);
    Q_PROPERTY(int uploadProgress READ uploadProgress NOTIFY uploadProgressChanged);
    Q_PROPERTY(int uploadProgressState READ uploadProgressState NOTIFY uploadProgressChanged);
    Q_PROPERTY(bool isRemoteComposing READ isRemoteComposing NOTIFY composingMessageReceived);
    Q_PROPERTY(ListEditorHelper* editor READ editor CONSTANT);

public:
    ChatModel(QObject *parent = NULL);
    void uploadProgressValueChanged(int progress);
    void uploadProgressStatusChanged(bool isUploadInProgress, bool error);
    void addMessageToList(LinphoneChatMessage *message);
    void updateMessage(LinphoneChatMessage *message, int downloadProgress = -1, int downloadOffset = -1, int downloadTotal = -1, int progressStatus = 0);

Q_SIGNALS:
    void messagesRead(QString sipAddress);
    void messageSent(LinphoneChatRoom *room, LinphoneChatMessage *lastMessage);
    void messagesDeleted(LinphoneChatRoom *room, LinphoneChatMessage *lastMessage);

    void messageHistoryChanged();
    void uploadProgressChanged();
    void composingMessageReceived();
    void remoteChateeChanged();

public Q_SLOTS:
    void onTextChanging();
    void onMessageReceived(LinphoneChatRoom *room, LinphoneChatMessage *message);
    void onComposingReceived(LinphoneChatRoom *room);
    bool setSelectedConversationSipAddress(QString sipAddress);
    void sendMessage(QString message);
    void updateMessagesList();
    void deleteItems(QList<QVariantList> indexPaths);

    void onFilePicked(const QStringList& filePicked);
    void openPicture(QString file);
    void downloadFile(QVariant variant);
    void copyToClipboard(QString text);

    void setPreviousPage(QString previousPage) {
        _previousPage = previousPage;
    }
    QString getPreviousPage() {
        return _previousPage;
    }

private:
    QString _previousPage;

    bb::cascades::GroupDataModel* dataModel() const {
        return _dataModel;
    }
    bb::cascades::GroupDataModel* _dataModel;

    ListEditorHelper *editor() const {
        return _listEditorHelper;
    }
    ListEditorHelper *_listEditorHelper;

    QString displayName() const {
        return _displayName;
    }
    QString _displayName;

    QString linphoneAddress() const {
        return _linphoneAddress;
    }
    QString _linphoneAddress;

    bool isNewConversation() const {
        return _isNewConversation;
    }
    void setNewConversation(const bool &isNewConversation) {
        _isNewConversation = isNewConversation;
        emit remoteChateeChanged();
    }
    bool _isNewConversation;

    bool isUploadInProgress() const {
        return _isUploadInProgress;
    }
    bool _isUploadInProgress;

    int uploadProgress() const {
        return _uploadProgress;
    }
    int _uploadProgress;

    int uploadProgressState() const {
        return _uploadProgressState;
    }
    int _uploadProgressState;

    bool isRemoteComposing() const {
        return _isRemoteComposing;
    }
    bool _isRemoteComposing;

    LinphoneChatRoom *_room;
};

#endif /* CHATMODEL_H_ */
