/*
 * ContactEditorView.qml
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
                contactEditorModel.editPicture(selectedFiles);
            }
        }
    ]
    
    onCreationCompleted: {
        // This is a needed hack since listeItemComponents are created in a different context,
        // so colors and fonts aren't available
        Qt.colors = colors
        Qt.titilliumWeb = titilliumWeb
        Qt.contactEditorModel = contactEditorModel
        Qt.filePicker = filePicker
    }
    
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
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
            imageSource: "asset:///images/cancel_edit.png"

            gestureHandlers: TapHandler {
                onTapped: {
                    tabDelegate.source = contactEditorModel.getPreviousPage();
                }
            }
        }

        Container {
            layoutProperties: StackLayoutProperties {
                spaceQuota: 2
            }
        }

        TopBarButton {
            imageSource: "asset:///images/contacts/delete.png"
            visibility: !contactEditorModel.isNewContact

            gestureHandlers: TapHandler {
                onTapped: {
                    if (!contactEditorModel.isNewContact) {
                        actionConfirmationScreen.visible = true;
                        actionConfirmationScreen.text = qsTr("Do you want to delete this contact?") + Retranslate.onLanguageChanged;
                        actionConfirmationScreen.confirmActionClicked.connect(onDelete);
                    }
                }
            }
        }

        TopBarButton {
            imageSource: "asset:///images/valid.png"

            gestureHandlers: TapHandler {
                onTapped: {
                    enabled = false;
                    contactEditorModel.saveChanges();
                    tabDelegate.source = contactEditorModel.getPreviousPage();
                }
            }
        }
    }

    ListView {
        bottomPadding: ui.sdu(6)
        verticalAlignment: VerticalAlignment.Bottom
        dataModel: contactEditorModel.sipAddresses

        listItemComponents: [
            ListItemComponent {
                type: "header"

                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.TopToBottom
                    }
                    leftPadding: ui.sdu(2)
                    rightPadding: ui.sdu(2)
                    topPadding: ui.sdu(2)

                    ContactAvatar {
                        imageSource: Qt.contactEditorModel.photo
                        maxHeight: ui.sdu(20)
                        maxWidth: ui.sdu(20)
                        minWidth: ui.sdu(20)
                        minHeight: ui.sdu(20)
                        horizontalAlignment: HorizontalAlignment.Center

                        gestureHandlers: TapHandler {
                            onTapped: {
                                Qt.filePicker.open();
                            }
                        }
                    }

                    Container {
                        layout: DockLayout {

                        }

                        Label {
                            verticalAlignment: VerticalAlignment.Top
                            text: qsTr("LAST NAME") + Retranslate.onLanguageChanged
                            textStyle.color: Qt.colors.colorE
                            textStyle.fontSize: FontSize.Small
                            textStyle.base: Qt.titilliumWeb.style
                        }

                        CustomListTextField {
                            topPadding: ui.sdu(6)
                            verticalAlignment: VerticalAlignment.Bottom
                            text: Qt.contactEditorModel.lastName
                            input.keyLayout: KeyLayout.Contact
                            inputMode: TextFieldInputMode.Text
                            textStyle.textAlign: TextAlign.Center

                            onTextFieldChanging: {
                                Qt.contactEditorModel.lastName = text
                            }
                        }
                    }

                    Container {
                        layout: DockLayout {

                        }
                        topPadding: ui.sdu(4)

                        Label {
                            verticalAlignment: VerticalAlignment.Top
                            text: qsTr("FIRST NAME") + Retranslate.onLanguageChanged
                            textStyle.color: Qt.colors.colorE
                            textStyle.fontSize: FontSize.Small
                            textStyle.base: Qt.titilliumWeb.style
                        }

                        CustomListTextField {
                            topPadding: ui.sdu(6)
                            verticalAlignment: VerticalAlignment.Bottom
                            text: Qt.contactEditorModel.firstName
                            input.keyLayout: KeyLayout.Contact
                            inputMode: TextFieldInputMode.Text
                            textStyle.textAlign: TextAlign.Center

                            onTextFieldChanging: {
                                Qt.contactEditorModel.firstName = text
                            }
                        }
                    }

                    Container {
                        layout: DockLayout {

                        }
                        horizontalAlignment: HorizontalAlignment.Fill
                        topPadding: ui.sdu(4)

                        Label {
                            verticalAlignment: VerticalAlignment.Bottom
                            text: qsTr("SIP ADDRESS") + Retranslate.onLanguageChanged
                            textStyle.color: Qt.colors.colorE
                            textStyle.fontSize: FontSize.Small
                            textStyle.base: Qt.titilliumWeb.style
                        }

                        ImageButton {
                            defaultImageSource: "asset:///images/contacts/add_field_default.png"
                            pressedImageSource: "asset:///images/contacts/add_field_over.png"
                            verticalAlignment: VerticalAlignment.Center
                            horizontalAlignment: HorizontalAlignment.Right
                            
                            onClicked: {
                                Qt.contactEditorModel.addNewSipAddressRow();
                            }
                        }
                    }
                }
            },
            ListItemComponent {
                type: "textfield"

                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.LeftToRight
                    }
                    leftPadding: ui.sdu(2)
                    rightPadding: ui.sdu(2)
                    bottomPadding: ui.sdu(2)
                    
                    CustomListTextField {
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1
                        }
                        text: ListItemData.value
                        input.keyLayout: KeyLayout.EmailAddress
                        inputMode: TextFieldInputMode.EmailAddress
                        textStyle.textAlign: TextAlign.Center
                        input.submitKey: SubmitKey.Done
                        input.submitKeyFocusBehavior: SubmitKeyFocusBehavior.Lose
    
                        onTextFieldChanging: {
                            Qt.contactEditorModel.updateSipAddressForIndex(ListItemData.id, text);
                        }
                    }
                    
                    ImageButton {
                        visible: !ListItemData.first // Don't allow to delete the first SIP address
                        defaultImageSource: "asset:///images/contacts/delete_field_default.png"
                        pressedImageSource: "asset:///images/contacts/delete_field_over.png"
                        verticalAlignment: VerticalAlignment.Center
                        horizontalAlignment: HorizontalAlignment.Right
                        
                        onClicked: {
                            Qt.contactEditorModel.deleteSipAddressRowAtIndex(ListItemData.id);
                        }
                    }
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
                return "textfield";
            } else {
                return "empty";
            }
        }
    }
    
    function onDelete() {
        actionConfirmationScreen.visible = false
        contactEditorModel.deleteContact()
        tabDelegate.source = "ContactsListView.qml"
    }
}
