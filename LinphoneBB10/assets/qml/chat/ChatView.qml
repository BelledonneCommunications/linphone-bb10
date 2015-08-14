/*
 * ChatView.qml
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
 */

import bb.cascades 1.4
import bb.cascades.pickers 1.0

import ".."
import "../custom_controls"

Container {
    attachedObjects: [
        FilePicker {
            id: filePicker
            type: FileType.Picture
            mode: FilePickerMode.Picker
            title: qsTr("Select picture") + Retranslate.onLanguageChanged
            onFileSelected: {
                chatListModel.chatModel.onFilePicked(selectedFiles);
                sendMessage.enabled = true;
            }
        }
    ]

    onCreationCompleted: {
        // This is a needed hack since listeItemComponents are created in a different context,
        // so colors and fonts aren't available
        Qt.colors = colors
        Qt.titilliumWeb = titilliumWeb
        
        chatListModel.chatModel.editor.isEditMode = false
        Qt.editor = chatListModel.chatModel.editor
    }

    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill

    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        minHeight: ui.sdu(15)
        background: colors.colorF
        visible: !bps.isKeyboardVisible

        TopBarButton {
            imageSource: "asset:///images/back.png"
            
            gestureHandlers: TapHandler {
                onTapped: {
                    tabDelegate.source = chatListModel.chatModel.getPreviousPage();
                }
            }
        }

        Container {
            layout: DockLayout {

            }
            layoutProperties: StackLayoutProperties {
                spaceQuota: 2
            }
            verticalAlignment: VerticalAlignment.Fill

            Label {
                visible: ! chatListModel.chatModel.isNewConversation
                text: chatListModel.chatModel.displayName
                textStyle.fontSize: FontSize.Large
                textStyle.base: titilliumWeb.style
                textStyle.color: colors.colorC
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
            }
        }

        TopBarButton {
            visible: ! chatListModel.chatModel.isNewConversation && !chatListModel.chatModel.editor.isEditMode && !(inCallModel.isInCall && inCallModel.sipUri == chatListModel.chatModel.linphoneAddress)
            imageSource: "asset:///images/chat/call_alt_start.png"

            gestureHandlers: TapHandler {
                onTapped: {
                    linphoneManager.call(chatListModel.chatModel.linphoneAddress);
                }
            }
        }
        
        TopBarButton {
            visible: inCallModel.isInCall && inCallModel.sipUri == chatListModel.chatModel.linphoneAddress
            imageSource: "asset:///images/chat/call_back.png"
            
            gestureHandlers: TapHandler {
                onTapped: {
                    inCallView.open();
                }
            }
        }

        TopBarButton {
            visible: !chatListModel.chatModel.isNewConversation && !chatListModel.chatModel.editor.isEditMode
            imageSource: "asset:///images/edit_list.png"
            
            gestureHandlers: TapHandler {
                onTapped: {
                    chatListModel.chatModel.editor.isEditMode = true
                }
            }
        }
        
        TopBarButton {
            imageSource: "asset:///images/select_all.png"
            visible: chatListModel.chatModel.editor.isEditMode && chatListModel.chatModel.editor.selectionSize == 0
            
            gestureHandlers: TapHandler {
                onTapped: {
                    chatListModel.chatModel.editor.selectAll(true);
                }
            }
        }
        
        TopBarButton {
            imageSource: "asset:///images/deselect_all.png"
            visible: chatListModel.chatModel.editor.isEditMode && chatListModel.chatModel.editor.selectionSize != 0
            
            gestureHandlers: TapHandler {
                onTapped: {
                    chatListModel.chatModel.editor.selectAll(false);
                }
            }
        }
        
        TopBarButton {
            imageSource: "asset:///images/delete.png"
            visible: chatListModel.chatModel.editor.isEditMode
            
            gestureHandlers: TapHandler {
                onTapped: {
                    if (chatListModel.chatModel.editor.selectionSize != 0) {
                        actionConfirmationScreen.visible = true
                        actionConfirmationMessage.text = qsTr("Are you sure you want to delete the selected messages?") + Retranslate.onLanguageChanged
                        confirmAction.deleteClicked.connect(onDelete)
                        cancelAction.cancelClicked.connect(onCancel)
                    } else {
                        chatListModel.chatModel.editor.isEditMode = false
                    }
                }
            }
        }
        
        Container {
            layoutProperties: StackLayoutProperties {
                spaceQuota: 2
            }
            visible: chatListModel.chatModel.isNewConversation
        }
    }
    
    CustomTextField {
        id: newConversationSipAddress
        leftPadding: ui.sdu(2)
        rightPadding: ui.sdu(2)
        topPadding: ui.sdu(2)
        visible: chatListModel.chatModel.isNewConversation
        input.keyLayout: KeyLayout.EmailAddress
        inputMode: TextFieldInputMode.EmailAddress
    }

    ListView {
        layout: FlowListLayout {
            headerMode: ListHeaderMode.Sticky
            orientation: LayoutOrientation.TopToBottom
        }
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
        dataModel: chatListModel.chatModel.dataModel
        stickToEdgePolicy: ListViewStickToEdgePolicy.End
        scrollIndicatorMode: ScrollIndicatorMode.ProportionalBar

        function itemType(data, indexPath) {
            if (data.isOutgoing)
                return "outgoing_item";
            return "incoming_item";
        }

        function downloadFile(message) {
            chatListModel.chatModel.downloadFile(message);
        }

        function openPicture(file) {
            chatListModel.chatModel.openPicture(file);
        }
        
        function copyToClipboard(text) {
            chatListModel.chatModel.copyToClipboard(text);
        }

        listItemComponents: [
            ListItemComponent {
                type: "outgoing_item"

                OutgoingChatView {
                    
                }
            },

            ListItemComponent {
                type: "incoming_item"

                IncomingChatView {
                    
                }
            }
        ]
    }

    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        minHeight: ui.sdu(15)
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Center
        background: colors.colorF
        visible: !chatListModel.chatModel.isUploadInProgress

        ImageButton {
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            defaultImageSource: "asset:///images/chat/chat_picture_default.png"
            pressedImageSource: "asset:///images/chat/chat_picture_over.png"
            opacity: enabled ? 1 : 0.2
            
            onClicked: {
                filePicker.open();
            }
        }

        TextField {
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            id: messageInput
            verticalAlignment: VerticalAlignment.Center
            inputMode: TextFieldInputMode.Chat
            input.submitKey: SubmitKey.EnterKey
            input.submitKeyFocusBehavior: SubmitKeyFocusBehavior.Keep
            input.keyLayout: KeyLayout.Text
            hintText: ""

            input {
                onSubmitted: {
                    sendMessage();
                }
            }
        }
        
        /*Label {
            text: "<html>&#x1F603;</html>"
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            
            gestureHandlers: TapHandler {
                onTapped: {
                    messageInput.text += "<html>&#x1F603;</html>" // The HTML tags are needed to display the emoji correctly
                }
            }
        }*/

        ImageButton {
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            defaultImageSource: "asset:///images/chat/chat_send_default.png"
            pressedImageSource: "asset:///images/chat/chat_send_over.png"
            opacity: enabled ? 1 : 0.2
            
            onClicked: {
                sendMessage();
            }
        }
    }
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        minHeight: ui.sdu(15)
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Center
        background: colors.colorF
        visible: chatListModel.chatModel.isUploadInProgress
        
        ProgressIndicator {
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            fromValue: 0
            toValue: 100
            value: chatListModel.chatModel.uploadProgress
            state: chatListModel.chatModel.uploadProgressState
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }
    }
    
    function sendMessage() {
        var success = true;
        if (chatListModel.chatModel.isNewConversation && newConversationSipAddress.text.length > 0) {
            success = chatListModel.chatModel.setSelectedConversationSipAddress(newConversationSipAddress.text);
        }
        
        if (messageInput.text.length > 0 && success) {
            chatListModel.chatModel.sendMessage(messageInput.text/*.replace("<html>", "").replace("</html>", "")*/); // Remove the html tags to only send the emoji character
            messageInput.text = "";
            messageInput.requestFocus();
        }
    }
    
    function onDelete() {
        actionConfirmationScreen.visible = false
        chatListModel.chatModel.editor.deleteSelection()
        chatListModel.chatModel.editor.isEditMode = false
    }
    
    function onCancel() {
        actionConfirmationScreen.visible = false
        chatListModel.chatModel.editor.isEditMode = false
    }
}
