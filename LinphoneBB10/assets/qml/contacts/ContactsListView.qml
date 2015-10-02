/*
 * ContactsListView.qml
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
        
        contactsList.scrollToItem(contactListModel.lastSelectedItemIndexPath, ScrollAnimation.None)
        contactListModel.resetLastSelectedItemPath()
        
        contactListModel.editor.isEditMode = false
        Qt.editor = contactListModel.editor
    }

    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        minHeight: ui.sdu(15)
        background: colors.colorF

        CustomToggleButton {
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            imageSource: "asset:///images/contacts/contacts_all_default.png"
            selectedImageSource: "asset:///images/contacts/contacts_all_selected.png"
            selected: !contactListModel.sipFilterEnabled
            visible: !contactListModel.editor.isEditMode
            
            gestureHandlers: TapHandler {
                onTapped: {
                    contactListModel.setSipFilter(false)
                }
            }
        }

        CustomToggleButton {
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            imageSource: "asset:///images/contacts/contacts_sip_default.png"
            selected: contactListModel.sipFilterEnabled
            selectedImageSource: "asset:///images/contacts/contacts_sip_selected.png"
            visible: !contactListModel.editor.isEditMode
            
            gestureHandlers: TapHandler {
                onTapped: {
                    contactListModel.setSipFilter(true)
                }
            }
        }

        Container {
            visible: !contactListModel.editor.isEditMode
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
        }
        
        TopBarButton {
            imageSource: "asset:///images/contacts/contact_add.png"
            visible: !contactListModel.editor.isEditMode
            
            gestureHandlers: TapHandler {
                onTapped: {
                    contactEditorModel.setSelectedContactId(-1);
                    contactEditorModel.setPreviousPage("ContactsListView.qml");
                    tabDelegate.source = "ContactEditorView.qml";
                }
            }
        }
        
        TopBarButton {
            imageSource: "asset:///images/edit_list.png"
            visible: !contactListModel.editor.isEditMode
            
            gestureHandlers: TapHandler {
                onTapped: {
                    contactListModel.editor.isEditMode = true
                }
            }
        }
        
        TopBarEditListControls {
            visible: contactListModel.editor.isEditMode
            selectionEmpty: contactListModel.editor.selectionSize == 0
            onCancelEdit: {
                contactListModel.editor.isEditMode = false;
            }
            onSelectAll: {
                contactListModel.editor.selectAll(true);
            }
            onDeselectAll: {
                contactListModel.editor.selectAll(false);
            }
            onDeleteSelected: {
                actionConfirmationScreen.visible = true;
                actionConfirmationScreen.text = qsTr("Are you sure you want to delete the selected contacts?") + Retranslate.onLanguageChanged;
                actionConfirmationScreen.confirmActionClicked.connect(onDelete);
                actionConfirmationScreen.cancelActionClicked.connect(onCancel);
            }
        }
    }
    
    CustomTextField {
        leftPadding: ui.sdu(2)
        rightPadding: ui.sdu(2)
        topPadding: ui.sdu(1)
        bottomPadding: ui.sdu(1)
        hintText: qsTr("Contact search") + Retranslate.onLanguageChanged
        
        onTextFieldChanging: {
            contactListModel.contactSearchFilter = text
        }
    }

    Container {
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
        horizontalAlignment: HorizontalAlignment.Fill

        ListView {
            id: contactsList
            dataModel: contactListModel.dataModel

            listItemComponents: [
                ListItemComponent {
                    type: "header"

                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.TopToBottom
                        }
                        background: Qt.colors.colorH
                        horizontalAlignment: HorizontalAlignment.Fill

                        Label {
                            text: ListItemData
                            horizontalAlignment: HorizontalAlignment.Center
                            textStyle.color: Qt.colors.colorA
                            textStyle.fontWeight: FontWeight.Bold
                            textStyle.base: Qt.titilliumWeb.style
                            textStyle.fontSize: FontSize.Large
                        }

                        CustomListDivider {

                        }
                    }
                },

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

                            ContactAvatar {
                                maxHeight: ui.sdu(13)
                                minHeight: ui.sdu(13)
                                maxWidth: ui.sdu(13)
                                minWidth: ui.sdu(13)
                                imageSource: ListItemData.contactPhoto
                                verticalAlignment: VerticalAlignment.Center
                                rightMargin: ui.sdu(2)
                            }

                            Label {
                                layoutProperties: StackLayoutProperties {
                                    spaceQuota: 1
                                }
                                text: ListItemData.displayName
                                textStyle.color: Qt.colors.colorC
                                textStyle.base: Qt.titilliumWeb.style
                                textStyle.fontSize: FontSize.Large
                                verticalAlignment: VerticalAlignment.Center
                            }
                            
                            ImageView {
                                visible: ListItemData.isLinphoneContact && !Qt.editor.isEditMode
                                imageSource: "asset:///images/presence/linphone_user.png"
                                scalingMethod: ScalingMethod.AspectFit
                                verticalAlignment: VerticalAlignment.Center
                            }
                            
                            CustomCheckBox {
                                verticalAlignment: VerticalAlignment.Center
                                enabled: false // This is because clicking on it will also trigger a click on the row, that will do the checkbox toggle
                            }
                        }

                        CustomListDivider {

                        }
                    }
                }
            ]

            onTriggered: {
                if (indexPath.length > 1) {
                    if (contactListModel.editor.isEditMode) {
                        var selectedItem = dataModel.data(indexPath);
                        Qt.editor.updateSelection(indexPath, !selectedItem.selected);
                    } else {
                        contactListModel.setSelectedContact(indexPath)
                        contactListModel.viewContact();
                        tabDelegate.source = "ContactDetailsView.qml"
                    }
                }
            }

            function itemType(data, indexPath) {
                if (indexPath.length == 1) {
                    return "header";
                } else {
                    return "item";
                }
            }
        }
    }
    
    function onDelete() {
        contactListModel.editor.deleteSelection()
        contactListModel.editor.isEditMode = false
    }
    
    function onCancel() {
        contactListModel.editor.isEditMode = false
    }
}
