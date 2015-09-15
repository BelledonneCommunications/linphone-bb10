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
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
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
        fillContactNumbers();
    }
    
    function fillContactNumbers() {
        contactNumbers.removeAll();
        
        for (var number in contactListModel.contactModel.numbersAndAddresses) {
            var item = contactDetailsNumber.createObject();
            item.label = contactListModel.contactModel.numbersAndAddresses[number];
            item.number = number;
            contactNumbers.add(item);
        }
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
                    actionConfirmationMessage.text = qsTr("Are you sure you want to delete this contact?") + Retranslate.onLanguageChanged
                    confirmAction.deleteClicked.connect(onDelete)
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

    ScrollView {
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            topPadding: ui.sdu(2)

            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center

                ContactAvatar {
                    maxHeight: ui.sdu(20)
                    maxWidth: ui.sdu(20)
                    minWidth: ui.sdu(20)
                    minHeight: ui.sdu(20)
                    imageSource: contactListModel.contactModel.photo
                    horizontalAlignment: HorizontalAlignment.Center
                }

                /*ImageView {
                    visible: contactListModel.contactModel.isSipContact
                    imageSource: "asset:///images/presence/linphone_user.png"
                    verticalAlignment: VerticalAlignment.Center
                    scalingMethod: ScalingMethod.AspectFit
                }*/
            }

            Label {
                text: contactListModel.contactModel.displayName
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontSize: FontSize.XLarge
                textStyle.color: colors.colorC
                textStyle.base: titilliumWeb.style
            }

            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.TopToBottom
                }
                id: contactNumbers
            }
        }
    }

    function onDelete() {
        actionConfirmationScreen.visible = false
        contactListModel.contactModel.deleteContact()
        tabDelegate.source = "ContactsListView.qml"
    }
}