/*
 * ContactDetailsView.qml
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
 */

import bb.cascades 1.4

import "../custom_controls"

Container {
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }
    
    attachedObjects: [
        ComponentDefinition {
            id: contactDetailsNumber                
            source: "ContactDetailsNumber.qml"
        }
    ]
    
    onCreationCompleted: {
        // This is a needed hack since listeItemComponents are created in a different context,
        // so colors and fonts aren't available
        Qt.colors = colors
        Qt.titilliumWeb = titilliumWeb
        Qt.contactModel = contactListModel.contactModel
    }

    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        minHeight: ui.sdu(15)
        background: colors.colorF
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill

        TopBarButton {
            imageSource: "asset:///images/back.png"

            gestureHandlers: TapHandler {
                onTapped: {
                    tabDelegate.source = "ContactsListView.qml"
                }
            }
        }

        Container {
            layout: DockLayout {

            }
            layoutProperties: StackLayoutProperties {
                spaceQuota: 2
            }
        }

        TopBarButton {
            imageSource: "asset:///images/contacts/delete.png"

            gestureHandlers: TapHandler {
                onTapped: {
                    actionConfirmationScreen.visible = true
                    actionConfirmationScreen.text = qsTr("Do you want to delete this contact?") + Retranslate.onLanguageChanged
                    actionConfirmationScreen.confirmActionClicked.connect(onDelete);
                }
            }
        }

        TopBarButton {
            imageSource: "asset:///images/edit.png"
            
            gestureHandlers: TapHandler {
                onTapped: {
                    contactEditorModel.setSelectedContactId(contactListModel.contactModel.contactId);
                    contactEditorModel.setPreviousPage("ContactDetailsView.qml");
                    tabDelegate.source = "ContactEditorView.qml";
                }
            }
        }
    }
    
    ContactHeader {
        photo: Qt.contactModel.photo
        displayName:Qt.contactModel.displayName
        visible: contactListModel.contactModel.dataModel.size() == 0
    }
    
    ListView {
        id: contactsList
        dataModel: contactListModel.contactModel.dataModel
        visible: contactListModel.contactModel.dataModel.size() > 0
        
        listItemComponents: [
            ListItemComponent {
                type: "header"
                
                ContactHeader {
                    photo: Qt.contactModel.photo
                    displayName:Qt.contactModel.displayName
                }
            },
            
            ListItemComponent {
                type: "item"
                
                ContactDetailsNumber {
                    label: ListItemData.label
                    number: ListItemData.number
                }
            },
            
            ListItemComponent {
                type: "empty"
                
                Container {
                    
                }
            }
        ]
        
        function itemType(data, indexPath) {
            if (indexPath.length == 1 && indexPath[0] == 0) {
                return "header";
            } else if (indexPath.length > 1) {
                return "item";
            } else {
                return "empty";
            }
        }
        
        function callNumber(number) {
            newOutgoingCallOrCallTransfer(number);
        }
        
        function chatNumber(number) {
            chatListModel.viewConversation(number);
            chatListModel.chatModel.setPreviousPage("../contacts/ContactDetailsView.qml");
            tabDelegate.source = "../chat/ChatConversationView.qml";
        }
    }

    function onDelete() {
        contactListModel.contactModel.deleteContact()
        tabDelegate.source = "ContactsListView.qml"
    }
}