/*
 * ChatModel.cpp
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

#include "ChatModel.h"
#include "src/linphone/LinphoneManager.h"
#include "src/utils/Misc.h"

#include <bb/system/InvokeManager.hpp>
#include <bb/cascades/ProgressIndicator>
#include <bb/system/Clipboard.hpp>

using namespace bb::cascades;
using namespace bb::system;

ChatModel::ChatModel(QObject *parent)
    : QObject(parent),
      _previousPage("ChatListView.qml"),
      _dataModel(new GroupDataModel(this)),
      _listEditorHelper(new ListEditorHelper(_dataModel)),
      _displayName(""),
      _linphoneAddress(""),
      _isNewConversation(true),
      _isUploadInProgress(false),
      _uploadProgress(0),
      _uploadProgressState(ProgressIndicatorState::Progress),
      _isRemoteComposing(false),
      _room(NULL)
{
    _dataModel->setGrouping(ItemGrouping::None);
    QStringList sortingKeys;
    sortingKeys << "id";
    _dataModel->setSortingKeys(sortingKeys);

    LinphoneManager *manager = LinphoneManager::getInstance();
    bool result = connect(manager, SIGNAL(messageReceived(LinphoneChatRoom*, LinphoneChatMessage*)), this, SLOT(onMessageReceived(LinphoneChatRoom*, LinphoneChatMessage*)));
    Q_ASSERT(result);

    result = connect(manager, SIGNAL(composingReceived(LinphoneChatRoom*)), this, SLOT(onComposingReceived(LinphoneChatRoom*)));
    Q_ASSERT(result);

    result = connect(this, SIGNAL(messagesRead(QString)), manager, SLOT(updateUnreadChatMessagesCount()));
    Q_ASSERT(result);

    result = connect(_listEditorHelper, SIGNAL(deleteRequested(QList<QVariantList>)), this, SLOT(deleteItems(QList<QVariantList>)));
    Q_ASSERT(result);
    Q_UNUSED(result);
}

void ChatModel::onMessageReceived(LinphoneChatRoom *room, LinphoneChatMessage *message)
{
    linphone_chat_message_ref(message);
    if (_room == room && _room) {
        addMessageToList(message);
        linphone_chat_room_mark_as_read(_room);
    }
}

bool ChatModel::setSelectedConversationSipAddress(QString sipAddress)
{
    _displayName = "";
    if (_dataModel != NULL) {
        _dataModel->clear();
    }
    _room = NULL;
    _isNewConversation = true;
    _linphoneAddress = "";

    if (!sipAddress.isEmpty()) {
        _isNewConversation = false;

        LinphoneManager *manager = LinphoneManager::getInstance();
        LinphoneCore *lc = manager->getLc();
        LinphoneAddress *address = linphone_core_interpret_url(lc, sipAddress.toUtf8().constData());
        if (!address) {
            return false;
        }

        _room = linphone_core_get_or_create_chat_room(lc, linphone_address_as_string_uri_only(address));
        if (_room) {
            ContactFound contact = ContactFetcher::getInstance()->findContact(linphone_address_get_username(address));
            if (contact.id >= 0) {
                _displayName = contact.displayName;
            } else {
                _displayName = GetDisplayNameFromLinphoneAddress(address);
            }
            _linphoneAddress = linphone_address_as_string(address);

            linphone_chat_room_mark_as_read(_room);
            emit messagesRead(sipAddress);

            updateMessagesList();
        }
        emit remoteChateeChanged();
        return true;
    }
    return false;
}

void ChatModel::onTextChanging()
{
    if (_room) {
        linphone_chat_room_compose(_room);
    }
}

static void onMessageStateChanged(LinphoneChatMessage *msg, LinphoneChatMessageState state, void *userData)
{
    ChatModel *thiz = (ChatModel *)userData;
    if (state == LinphoneChatMessageStateInProgress) {
        thiz->addMessageToList(msg);
    } else {
        thiz->updateMessage(msg);
    }
}

void ChatModel::sendMessage(QString message)
{
    if (_room) {
        LinphoneChatMessage *msg = linphone_chat_room_create_message(_room, message.toUtf8().constData());
        linphone_chat_room_send_message2(_room, msg, onMessageStateChanged, this);
        emit messageSent(_room, msg);
    }
}

static QVariantMap updateFileTransferInformations(QVariantMap entry, LinphoneChatMessage *message, int downloadProgress, int progressStatus)
{
    const LinphoneContent *content = linphone_chat_message_get_file_transfer_information(message);
    const char *external_body_url = linphone_chat_message_get_external_body_url(message);
    bool isFileTransfer = content || external_body_url;
    entry["isFileTransferMessage"] = isFileTransfer;
    const char *appData = linphone_chat_message_get_appdata(message);

    bool isAlreadyDownloaded = appData != NULL;
    entry["isImageDownloaded"] = isAlreadyDownloaded;
    if (isFileTransfer) {
        entry["downloadProgress"] = downloadProgress;
        entry["downloadProgressState"] = progressStatus;
        if (isAlreadyDownloaded) {
            entry["imageSource"] = "file://" + QString(appData);
        }
    }

    return entry;
}

static QVariantMap setMessageDeliveryState(QVariantMap entry, LinphoneChatMessage *message)
{
    LinphoneChatMessageState state = linphone_chat_message_get_state(message);
    QString stateImage = "/images/chat/chat_message_not_delivered.png";
    if (state == LinphoneChatMessageStateInProgress) {
        stateImage = "/images/chat/chat_message_inprogress.png";
    } else if (state == LinphoneChatMessageStateDelivered) {
        stateImage = "/images/chat/chat_message_delivered.png";
    }

    entry["deliveryState"] = stateImage;
    return entry;
}

static QVariantMap fillEntryWithMessageValues(QVariantMap entry, LinphoneChatMessage *message)
{
    entry["id"] = linphone_chat_message_get_storage_id(message);
    entry["message"] = QVariant::fromValue<LinphoneChatMessage*>(message);

    const char *text = linphone_chat_message_get_text(message);
    entry["text"] = QString::fromUtf8(text);

    time_t time = linphone_chat_message_get_time(message);
    const LinphoneAddress* fromAddr = linphone_chat_message_get_from_address(message);
    QString from = GetDisplayNameFromLinphoneAddress(fromAddr);
    QString date = FormatDateForChat(time);

    bool_t isOutgoing = linphone_chat_message_is_outgoing(message);
    entry["isOutgoing"] = isOutgoing;
    if (isOutgoing) {
        LinphoneManager *manager = LinphoneManager::getInstance();
        LinphoneCore *lc = manager->getLc();
        LpConfig *lp = linphone_core_get_config(lc);
        entry["contactPhoto"] = lp_config_get_string(lp, "app", "avatar_url", "/images/avatar.png");
    } else {
        ContactFound cf = ContactFetcher::getInstance()->findContact(linphone_address_get_username(fromAddr));
        if (cf.id >= 0) {
            from = cf.displayName;
            entry["contactPhoto"] = cf.smallPicturePath;
        } else {
            entry["contactPhoto"] = "/images/avatar.png";
        }
    }

    QString timeAndFrom = GetTime(time) + " - " + from;
    if (date.length() > 0) {
        timeAndFrom = date + " " + timeAndFrom;
    }
    entry["timeAndFrom"] = timeAndFrom;

    entry = updateFileTransferInformations(entry, message, -1, ProgressIndicatorState::Progress);

    entry = setMessageDeliveryState(entry, message);

    entry["selected"] = false;
    return entry;
}

static void addChatMessageToListModel(void *item, void *user_data)
{
    GroupDataModel *model = (GroupDataModel *)user_data;
    LinphoneChatMessage *message = (LinphoneChatMessage *)item;

    QVariantMap entry;
    entry = fillEntryWithMessageValues(entry, message);
    model->insert(entry);
}

void ChatModel::updateMessagesList()
{
    if (_dataModel == NULL)
        return;

    _dataModel->clear();

    if (_room) {
        MSList *messages = linphone_chat_room_get_history(_room, 0);
        ms_list_for_each2(messages, addChatMessageToListModel, _dataModel);
        emit messageHistoryChanged();
    }
}

void ChatModel::updateMessage(LinphoneChatMessage *message, int downloadProgress, int progressStatus)
{
    foreach (QVariantMap entry, _dataModel->toListOfMaps()) {
        LinphoneChatMessage *msg = entry.value("message").value<LinphoneChatMessage*>();
        if (linphone_chat_message_get_storage_id(message) == linphone_chat_message_get_storage_id(msg)) {
            QVariantList indexPath = _dataModel->findExact(entry);
            entry = updateFileTransferInformations(entry, message, downloadProgress, progressStatus);
            entry = setMessageDeliveryState(entry, message);
            _dataModel->updateItem(indexPath, entry);
            break;
        }
    }
    emit messageHistoryChanged();
}

void ChatModel::addMessageToList(LinphoneChatMessage *message)
{
    if (_dataModel == NULL || message == NULL)
        return;

    addChatMessageToListModel(message, _dataModel);
    emit messageHistoryChanged();
}

void ChatModel::onComposingReceived(LinphoneChatRoom *room)
{
    _isRemoteComposing = linphone_chat_room_is_remote_composing(room);
    emit composingMessageReceived();
}

void ChatModel::deleteItems(QList<QVariantList> indexPaths)
{
    if (!_room) {
        return;
    }

    foreach(QVariantList indexPath, indexPaths) {
        QVariantMap entry = _dataModel->data(indexPath).toMap();
        LinphoneChatMessage *message = entry.value("message").value<LinphoneChatMessage*>();

        if (!message) {
            continue;
        }

        linphone_chat_room_delete_message(_room, message);

        _dataModel->removeAt(indexPath);
    }

    emit messageHistoryChanged();

    MSList *history = linphone_chat_room_get_history(_room, 1);
    LinphoneChatMessage *lastMessage = NULL;
    if (ms_list_size(history) > 0) {
        lastMessage = (LinphoneChatMessage *)ms_list_nth_data(history, 0);
    }
    emit messagesDeleted(_room, lastMessage);
}

void ChatModel::openPicture(QString file)
{
    InvokeManager invokeManager;
    InvokeRequest invokeRequest;

    invokeRequest.setTarget("sys.pictures.card.previewer");
    invokeRequest.setAction("bb.action.VIEW");
    invokeRequest.setMimeType("");
    invokeRequest.setUri(file);

    invokeManager.invoke(invokeRequest);
}

void ChatModel::uploadProgressStatusChanged(bool isUploadInProgress, bool error)
{
    _uploadProgress = 0;
    _isUploadInProgress = isUploadInProgress;
    if (isUploadInProgress) {
        _uploadProgressState = ProgressIndicatorState::Progress;
    } else {
        if (error) {
            _uploadProgressState = ProgressIndicatorState::Error;
        } else {
            _uploadProgressState = ProgressIndicatorState::Complete;
        }
    }
    emit uploadProgressChanged();
}

void ChatModel::uploadProgressValueChanged(int progress)
{
    _uploadProgress = progress;
    if (progress == 100) {
        _uploadProgressState = ProgressIndicatorState::Complete;
    }
    emit uploadProgressChanged();
}

static void file_transfer_upload_state_changed(LinphoneChatMessage *message, LinphoneChatMessageState state) {
    ChatModel *thiz = (ChatModel *)linphone_chat_message_get_user_data(message);

    switch (state) {
    case LinphoneChatMessageStateFileTransferError:
        thiz->uploadProgressStatusChanged(false, true);
        break;
    case LinphoneChatMessageStateFileTransferDone:
        thiz->uploadProgressStatusChanged(false, false);
        break;
    case LinphoneChatMessageStateInProgress:
        thiz->addMessageToList(message);
        break;
    default:
        thiz->updateMessage(message);
        break;
    }
}

static void file_transfer_upload_progress_indication(LinphoneChatMessage *message, const LinphoneContent* content, size_t offset, size_t total)
{
    ChatModel *thiz = (ChatModel *)linphone_chat_message_get_user_data(message);
    thiz->uploadProgressValueChanged(offset * 100 / total);

    Q_UNUSED(content);
}

void ChatModel::onFilePicked(const QStringList &filePicked)
{
    if (_room && filePicked.size() > 0) {
        QString filePath = filePicked.first();
        QFile file(filePath);
        if (file.exists()) {
            QFileInfo infos(file.fileName());
            QString localFile = QDir::homePath() + "/" + infos.fileName();
            QFile::copy(filePath, localFile);

            LinphoneCore *lc = linphone_chat_room_get_core(_room);
            LinphoneContent *content = linphone_core_create_content(lc);
            linphone_content_set_type(content, "image");
            linphone_content_set_subtype(content, "jpeg");
            linphone_content_set_size(content, file.size());
            linphone_content_set_name(content, infos.fileName().toUtf8().constData());
            LinphoneChatMessage *message = linphone_chat_room_create_file_transfer_message(_room, content);

            LinphoneChatMessageCbs *cbs = linphone_chat_message_get_callbacks(message);
            linphone_chat_message_cbs_set_msg_state_changed(cbs, file_transfer_upload_state_changed);
            linphone_chat_message_cbs_set_file_transfer_progress_indication(cbs, file_transfer_upload_progress_indication);

            const char *localFilePath = strdup(localFile.toUtf8().constData());
            linphone_chat_message_set_file_transfer_filepath(message, localFilePath);
            linphone_chat_message_set_appdata(message, localFilePath);
            linphone_chat_message_set_user_data(message, this);
            linphone_chat_room_send_chat_message(_room, message);
            emit messageSent(_room, message);
            uploadProgressStatusChanged(true, false);
        }
    }
}

static void file_transfer_download_state_changed(LinphoneChatMessage *message, LinphoneChatMessageState state) {
    ChatModel *thiz = (ChatModel *)linphone_chat_message_get_user_data(message);

    switch (state) {
    case LinphoneChatMessageStateFileTransferDone:
        linphone_chat_message_set_appdata(message, linphone_chat_message_get_file_transfer_filepath(message));
        thiz->updateMessage(message, 100, ProgressIndicatorState::Complete);
        break;
    case LinphoneChatMessageStateFileTransferError:
        thiz->updateMessage(message, 0, ProgressIndicatorState::Error);
        break;
    case LinphoneChatMessageStateInProgress:
    default:
        break;
    }
}

static void file_transfer_download_progress_indication(LinphoneChatMessage *message, const LinphoneContent* content, size_t offset, size_t total)
{
    ChatModel *thiz = (ChatModel *)linphone_chat_message_get_user_data(message);
    thiz->updateMessage(message, offset * 100 / total, ProgressIndicatorState::Progress);

    Q_UNUSED(content);
}

void ChatModel::downloadFile(QVariant entry)
{
    LinphoneChatMessage *message = entry.value<LinphoneChatMessage*>();

    QString file = QDir::homePath();
    const LinphoneContent *content = linphone_chat_message_get_file_transfer_information(message);
    const char *external_body_url = linphone_chat_message_get_external_body_url(message);
    if (content) {
       file = file + "/" + linphone_content_get_name(content);
    } else if (external_body_url) {
        QStringList split = QString(external_body_url).split("/");
        file = file + "/" + split.value(split.length() - 1);
    }

    linphone_chat_message_set_user_data(message, this);
    LinphoneChatMessageCbs *cbs = linphone_chat_message_get_callbacks(message);
    linphone_chat_message_cbs_set_msg_state_changed(cbs, file_transfer_download_state_changed);
    linphone_chat_message_cbs_set_file_transfer_progress_indication(cbs, file_transfer_download_progress_indication);

    const char *downloadedFile = strdup(file.toUtf8().constData());
    linphone_chat_message_set_file_transfer_filepath(message, downloadedFile);
    linphone_chat_message_download_file(message);
}

void ChatModel::copyToClipboard(QString text) {
    bb::system::Clipboard clipboard;
    clipboard.clear();
    clipboard.insert("text/plain", text.toUtf8());
}
