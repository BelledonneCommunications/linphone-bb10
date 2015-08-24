/*
 * HistoryListView.qml
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
        Qt.colors = colors;
        Qt.titilliumWeb = titilliumWeb
        
        historyList.scrollToItem(historyListModel.lastSelectedItemIndexPath, ScrollAnimation.None)
        historyListModel.resetLastSelectedItemPath()
        
        historyListModel.editor.isEditMode = false
        Qt.editor = historyListModel.editor
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
            imageSource: "asset:///images/history/history_all_default.png"
            selectedImageSource: "asset:///images/history/history_all_selected.png"
            selected: !historyListModel.missedFilterEnabled
            background: colors.colorF
            
            onTouch: {
                if (event.isDown() || event.isMove()) {
                    background = colors.colorE
                } else if (event.isUp() || event.isCancel()) {
                    background = colors.colorF
                }
            }
            
            onTouchExit: {
                background = colors.colorF
            }
            
            gestureHandlers: TapHandler {
                onTapped: {
                    historyListModel.setMissedFilter(false)
                }
            }
        }
        
        CustomToggleButton {
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            selected: historyListModel.missedFilterEnabled
            imageSource: "asset:///images/history/history_missed_default.png"
            selectedImageSource: "asset:///images/history/history_missed_selected.png"
            background: colors.colorF
            
            onTouch: {
                if (event.isDown() || event.isMove()) {
                    background = colors.colorE
                } else if (event.isUp() || event.isCancel()) {
                    background = colors.colorF
                }
            }
            
            onTouchExit: {
                background = colors.colorF
            }
            
            gestureHandlers: TapHandler {
                onTapped: {
                    historyListModel.setMissedFilter(true)
                }
            }
        }
        
        Container {
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
        }
        
        Container {
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            visible: !historyListModel.editor.isEditMode
        }
        
        TopBarButton {
            imageSource: "asset:///images/edit_list.png"
            visible: !historyListModel.editor.isEditMode
            
            gestureHandlers: TapHandler {
                onTapped: {
                    historyListModel.editor.isEditMode = true
                }
            }
        }
        
        TopBarButton {
            imageSource: "asset:///images/select_all.png"
            visible: historyListModel.editor.isEditMode && historyListModel.editor.selectionSize == 0
            
            gestureHandlers: TapHandler {
                onTapped: {
                    historyListModel.editor.selectAll(true);
                }
            }
        }
        
        TopBarButton {
            imageSource: "asset:///images/deselect_all.png"
            visible: historyListModel.editor.isEditMode && historyListModel.editor.selectionSize != 0
            
            gestureHandlers: TapHandler {
                onTapped: {
                    historyListModel.editor.selectAll(false);
                }
            }
        }
        
        TopBarButton {
            imageSource: "asset:///images/delete.png"
            visible: historyListModel.editor.isEditMode
            
            gestureHandlers: TapHandler {
                onTapped: {
                    if (historyListModel.editor.selectionSize != 0) {
                        actionConfirmationScreen.visible = true
                        actionConfirmationMessage.text = qsTr("Are you sure you want to delete the selected logs?") + Retranslate.onLanguageChanged
                        confirmAction.deleteClicked.connect(onDelete)
                        cancelAction.cancelClicked.connect(onCancel)
                    } else {
                        historyListModel.editor.isEditMode = false
                    }
                }
            }
        }
    }

    ListView {
        id: historyList
        dataModel: historyListModel.dataModel

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
                            maxWidth: ui.sdu(13)
                            minHeight: ui.sdu(13)
                            minWidth: ui.sdu(13)
                            imageSource: ListItemData.contactPhoto
                            verticalAlignment: VerticalAlignment.Center
                            rightMargin: ui.sdu(2)
                        }
                        
                        ImageView {
                            minWidth: ui.sdu(6.5)
                            minHeight: ui.sdu(6.5)
                            imageSource: ListItemData.directionPicture
                            verticalAlignment: VerticalAlignment.Center
                            scalingMethod: ScalingMethod.AspectFit
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
                        
                        ImageButton {
                            verticalAlignment: VerticalAlignment.Center
                            rightMargin: ui.sdu(2)
                            defaultImageSource: "asset:///images/history/list_details_default.png"
                            pressedImageSource: "asset:///images/history/list_details_over.png"
                            visible: !Qt.editor.isEditMode
                            
                            onClicked: {
                                itemRoot.ListItem.view.viewHistory(itemRoot.ListItem.indexPath, ListItemData.log);
                            }
                        }
                        
                        CustomCheckBox {
                            verticalAlignment: VerticalAlignment.Center
                        }
                    }
                    
                    CustomListDivider {
                        
                    }
                }
            }
        ]

        onTriggered: {
            if (indexPath.length > 1 && !historyListModel.editor.isEditMode) {
                var selectedItem = dataModel.data(indexPath);
                linphoneManager.call(selectedItem.remote);
            }
        }
        
        function viewHistory(indexPath, log) {
            historyListModel.viewHistory(indexPath, log);
            tabDelegate.source = "HistoryView.qml"
        }

        function itemType(data, indexPath) {
            if (indexPath.length == 1) {
                return "header";
            } else {
                return "item";
            }
        }
    }
    
    function onDelete() {
        actionConfirmationScreen.visible = false
        historyListModel.editor.deleteSelection()
        historyListModel.editor.isEditMode = false
    }
    
    function onCancel() {
        actionConfirmationScreen.visible = false
        historyListModel.editor.isEditMode = false
    }
}
