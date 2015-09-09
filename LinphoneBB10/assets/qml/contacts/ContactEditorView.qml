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
            imageCropEnabled: true
            title: qsTr("Select picture") + Retranslate.onLanguageChanged
            onFileSelected: {
                contactEditorModel.editPicture(selectedFiles);
            }
        }
    ]
    
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
            imageSource: "asset:///images/back.png"

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
                        actionConfirmationScreen.visible = true
                        actionConfirmationMessage.text = qsTr("Are you sure you want to delete this contact?") + Retranslate.onLanguageChanged
                        confirmAction.deleteClicked.connect(onDelete)
                    }
                }
            }
        }

        TopBarButton {
            imageSource: "asset:///images/valid.png"

            gestureHandlers: TapHandler {
                onTapped: {
                    contactEditorModel.saveChanges();
                    tabDelegate.source = contactEditorModel.getPreviousPage();
                }
            }
        }
    }

    ScrollView {
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            leftPadding: ui.sdu(2)
            rightPadding: ui.sdu(2)
            topPadding: ui.sdu(2)

            ContactAvatar {
                imageSource: contactEditorModel.photo
                maxHeight: ui.sdu(20)
                maxWidth: ui.sdu(20)
                minWidth: ui.sdu(20)
                minHeight: ui.sdu(20)
                horizontalAlignment: HorizontalAlignment.Center
                
                gestureHandlers: TapHandler {
                    onTapped: {
                        filePicker.open();
                    }
                }
            }

            Container {
                layout: DockLayout {

                }

                Label {
                    verticalAlignment: VerticalAlignment.Top
                    text: qsTr("Last Name") + Retranslate.onLanguageChanged
                    textStyle.color: colors.colorD
                    textStyle.fontSize: FontSize.Small
                    textStyle.base: titilliumWeb.style
                }

                CustomTextField {
                    topPadding: ui.sdu(6)
                    verticalAlignment: VerticalAlignment.Bottom
                    text: contactEditorModel.lastName
                    input.keyLayout: KeyLayout.Contact
                    inputMode: TextFieldInputMode.Text
                    textStyle.textAlign: TextAlign.Center

                    onTextFieldChanging: {
                        contactEditorModel.lastName = text
                    }
                }
            }

            Container {
                layout: DockLayout {

                }
                topPadding: ui.sdu(4)

                Label {
                    verticalAlignment: VerticalAlignment.Top
                    text: qsTr("First Name") + Retranslate.onLanguageChanged
                    textStyle.color: colors.colorD
                    textStyle.fontSize: FontSize.Small
                    textStyle.base: titilliumWeb.style
                }

                CustomTextField {
                    topPadding: ui.sdu(6)
                    verticalAlignment: VerticalAlignment.Bottom
                    text: contactEditorModel.firstName
                    input.keyLayout: KeyLayout.Contact
                    inputMode: TextFieldInputMode.Text
                    textStyle.textAlign: TextAlign.Center

                    onTextFieldChanging: {
                        contactEditorModel.firstName = text
                    }
                }
            }

            Container {
                layout: DockLayout {

                }
                topPadding: ui.sdu(4)

                Label {
                    verticalAlignment: VerticalAlignment.Top
                    text: qsTr("SIP Address") + Retranslate.onLanguageChanged
                    textStyle.color: colors.colorD
                    textStyle.fontSize: FontSize.Small
                    textStyle.base: titilliumWeb.style
                }

                CustomTextField {
                    topPadding: ui.sdu(6)
                    verticalAlignment: VerticalAlignment.Bottom
                    text: contactEditorModel.sipAddress
                    input.keyLayout: KeyLayout.EmailAddress
                    inputMode: TextFieldInputMode.EmailAddress
                    textStyle.textAlign: TextAlign.Center
                    input.submitKey: SubmitKey.Done
                    input.submitKeyFocusBehavior: SubmitKeyFocusBehavior.Lose

                    onTextFieldChanging: {
                        contactEditorModel.sipAddress = text
                    }
                }
            }
        }
    }
    
    function onDelete() {
        actionConfirmationScreen.visible = false
        contactEditorModel.deleteContact()
        tabDelegate.source = "ContactsListView.qml"
    }
}
