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
            visible: !chatListModel.editor.isEditMode
            
            gestureHandlers: TapHandler {
                onTapped: {
                    chatListModel.newConversation();
                    chatListModel.chatModel.setPreviousPage("ChatListView.qml");
                    tabDelegate.source = "ChatConversationView.qml"
                }
            }
        }

        Container {
            layoutProperties: StackLayoutProperties {
                spaceQuota: 3
            }
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
        
        TopBarEditListControls {
            visible: chatListModel.editor.isEditMode
            selectionSize: chatListModel.editor.selectionSize
            itemsCount: chatListModel.editor.itemsCount
            onCancelEdit: {
                chatListModel.editor.isEditMode = false;
            }
            onSelectAll: {
                chatListModel.editor.selectAll(true);
            }
            onDeselectAll: {
                chatListModel.editor.selectAll(false);
            }
            onDeleteSelected: {
                actionConfirmationScreen.visible = true;
                actionConfirmationScreen.text = qsTr("Do you want to delete selected conversations?") + Retranslate.onLanguageChanged;
                actionConfirmationScreen.confirmActionClicked.connect(onDelete);
                actionConfirmationScreen.cancelActionClicked.connect(onCancel);
            }
        }
    }

    Container {
        layout: DockLayout {
            
        }
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
        horizontalAlignment: HorizontalAlignment.Fill

        ListView {
            dataModel: chatListModel.dataModel
            visible: chatListModel.dataModel.size() > 0
            
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
                                        visible: ListItemData.unreadCount > 0 && !Qt.editor.isEditMode

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
                                        enabled: false // This is because clicking on it will also trigger a click on the row, that will do the checkbox toggle
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
                if (indexPath.length) {
                    if (chatListModel.editor.isEditMode) {
                        var selectedItem = dataModel.data(indexPath);
                        Qt.editor.updateSelection(indexPath, !selectedItem.selected);
                    } else {
                        chatListModel.viewConversation(indexPath);
                        chatListModel.chatModel.setPreviousPage("ChatListView.qml");
                        tabDelegate.source = "ChatConversationView.qml";
                    }
                }
            }
        }
        
        Label {
            visible: chatListModel.dataModel.size() == 0
            text: qsTr("No conversations") + Retranslate.onLanguageChanged
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            textStyle.fontSize: FontSize.XLarge
            textStyle.color: colors.colorC
            textStyle.base: titilliumWeb.style
        }
    }
    
    function onDelete() {
        chatListModel.editor.deleteSelection()
        chatListModel.editor.isEditMode = false
    }
    
    function onCancel() {
        chatListModel.editor.isEditMode = false
    }
}