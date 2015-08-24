/*
 * ChatListView.qml
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

import "../custom_controls"

Container {
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }

    onCreationCompleted: {
        // This is a needed hack since listeItemComponents are created in a different context,
        // so colors and fonts aren't available
        Qt.colors = colors
        Qt.titilliumWeb = titilliumWeb
        
        chatListModel.editor.isEditMode = false
        Qt.editor = chatListModel.editor
    }

    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        minHeight: ui.sdu(15)
        background: colors.colorF

        TopBarButton {
            imageSource: "asset:///images/chat/chat_add.png"
            
            gestureHandlers: TapHandler {
                onTapped: {
                    chatListModel.newConversation();
                    chatListModel.chatModel.setPreviousPage("ChatListView.qml");
                    tabDelegate.source = "ChatView.qml"
                }
            }
        }

        Container {
            layoutProperties: StackLayoutProperties {
                spaceQuota: 2
            }
        }
        
        Container {
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            visible: !chatListModel.editor.isEditMode
        }

        TopBarButton {
            imageSource: "asset:///images/edit_list.png"
            visible: !chatListModel.editor.isEditMode
            
            gestureHandlers: TapHandler {
                onTapped: {
                    chatListModel.editor.isEditMode = true
                }
            }
        }
        
        TopBarButton {
            imageSource: "asset:///images/select_all.png"
            visible: chatListModel.editor.isEditMode && chatListModel.editor.selectionSize == 0
            
            gestureHandlers: TapHandler {
                onTapped: {
                    chatListModel.editor.selectAll(true);
                }
            }
        }
        
        TopBarButton {
            imageSource: "asset:///images/deselect_all.png"
            visible: chatListModel.editor.isEditMode && chatListModel.editor.selectionSize != 0
            
            gestureHandlers: TapHandler {
                onTapped: {
                    chatListModel.editor.selectAll(false);
                }
            }
        }
        
        TopBarButton {
            imageSource: "asset:///images/delete.png"
            visible: chatListModel.editor.isEditMode
            
            gestureHandlers: TapHandler {
                onTapped: {
                    if (chatListModel.editor.selectionSize != 0) {
                        actionConfirmationScreen.visible = true
                        actionConfirmationMessage.text = qsTr("Are you sure you want to delete the selected conversations?") + Retranslate.onLanguageChanged
                        confirmAction.deleteClicked.connect(onDelete)
                        cancelAction.cancelClicked.connect(onCancel)
                    } else {
                        chatListModel.editor.isEditMode = false
                    }
                }
            }
        }
    }

    Container {
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
        horizontalAlignment: HorizontalAlignment.Fill

        ListView {
            dataModel: chatListModel.dataModel
            
            listItemComponents: [
                ListItemComponent {
                    type: "item"

                    Container {
                        id: itemRoot
                        layout: StackLayout {
                            orientation: LayoutOrientation.TopToBottom
                        }

                        Container {
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }
                            background: Qt.colors.colorH
                            topPadding: ui.sdu(1)
                            bottomPadding: ui.sdu(1)
                            leftPadding: ui.sdu(2)
                            rightPadding: ui.sdu(2)
                            horizontalAlignment: HorizontalAlignment.Fill

                            Container {
                                layout: DockLayout {

                                }
                                verticalAlignment: VerticalAlignment.Fill
                                horizontalAlignment: HorizontalAlignment.Center
                                minHeight: ui.sdu(20)
                                maxHeight: ui.sdu(20)

                                ContactAvatar {
                                    imageSource: ListItemData.contactPhoto
                                    maxHeight: ui.sdu(13)
                                    minHeight: ui.sdu(13)
                                    maxWidth: ui.sdu(13)
                                    minWidth: ui.sdu(13)
                                    horizontalAlignment: HorizontalAlignment.Center
                                    verticalAlignment: VerticalAlignment.Top
                                }

                                Label {
                                    text: ListItemData.displayTime
                                    textStyle.base: Qt.titilliumWeb.style
                                    textStyle.fontWeight: FontWeight.Bold
                                    textStyle.color: Qt.colors.colorA
                                    horizontalAlignment: HorizontalAlignment.Center
                                    verticalAlignment: VerticalAlignment.Bottom
                                }
                            }

                            Container {
                                layout: DockLayout {
                                    
                                }
                                layoutProperties: StackLayoutProperties {
                                    spaceQuota: 1
                                }
                                leftMargin: ui.sdu(2)

                                Container {
                                    layout: StackLayout {
                                        orientation: LayoutOrientation.LeftToRight
                                    }
                                    verticalAlignment: VerticalAlignment.Top

                                    Label {
                                        layoutProperties: StackLayoutProperties {
                                            spaceQuota: 1
                                        }
                                        visible: ListItemData.unreadCount > 0
                                        text: ListItemData.displayName
                                        textStyle.base: Qt.titilliumWeb.style
                                        textStyle.fontWeight: FontWeight.Bold
                                        textStyle.fontSize: FontSize.Large
                                        textStyle.color: Qt.colors.colorB
                                    }
                                    
                                    Label {
                                        layoutProperties: StackLayoutProperties {
                                            spaceQuota: 1
                                        }
                                        visible: ListItemData.unreadCount <= 0
                                        text: ListItemData.displayName
                                        textStyle.base: Qt.titilliumWeb.style
                                        textStyle.fontSize: FontSize.Large
                                        textStyle.color: Qt.colors.colorB
                                    }

                                    Container {
                                        layout: DockLayout {

                                        }
                                        horizontalAlignment: HorizontalAlignment.Center
                                        verticalAlignment: VerticalAlignment.Center
                                        visible: ListItemData.unreadCount > 0

                                        ImageView {
                                            imageSource: "asset:///images/chat/chat_list_indicator.png"
                                            horizontalAlignment: HorizontalAlignment.Center
                                            verticalAlignment: VerticalAlignment.Center
                                        }

                                        Label {
                                            text: ListItemData.unreadCount
                                            textStyle.base: Qt.titilliumWeb.style
                                            textStyle.fontSize: FontSize.Small
                                            textStyle.fontWeight: FontWeight.Bold
                                            textStyle.color: Qt.colors.colorH
                                            horizontalAlignment: HorizontalAlignment.Center
                                            verticalAlignment: VerticalAlignment.Center
                                        }
                                    }
                                    
                                    CustomCheckBox {
                                    
                                    }
                                }

                                Container {
                                    verticalAlignment: VerticalAlignment.Bottom
                                    topPadding: ui.sdu(8)
                                    
                                    Label {
                                        horizontalAlignment: HorizontalAlignment.Left
                                        visible: !ListItemData.isFileTransferMessage
                                        text: ListItemData.text
                                        textStyle.fontSize: FontSize.Small
                                        textStyle.base: Qt.titilliumWeb.style
                                        textStyle.color: Qt.colors.colorD
                                        multiline: true
                                        autoSize.maxLineCount: 2
                                    }
                                    
                                    Container {
                                        topPadding: ui.sdu(1)
                                        
                                        ImageView {
                                            imageSource: ListItemData.imageSource
                                            visible: ListItemData.isFileTransferMessage
                                            scalingMethod: ScalingMethod.AspectFit
                                        }
                                    }
                                }
                            }
                        }

                        CustomListDivider {

                        }
                    }
                }
            ]

            onTriggered: {
                if (indexPath.length && !chatListModel.editor.isEditMode) {
                    chatListModel.viewConversation(indexPath);
                    chatListModel.chatModel.setPreviousPage("ChatListView.qml");
                    tabDelegate.source = "ChatView.qml";
                }
            }
        }
    }
    
    function onDelete() {
        actionConfirmationScreen.visible = false
        chatListModel.editor.deleteSelection()
        chatListModel.editor.isEditMode = false
    }
    
    function onCancel() {
        actionConfirmationScreen.visible = false
        chatListModel.editor.isEditMode = false
    }
}