/*
 * HistoryDetailsView.qml
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
            id: historyDetailsItem                       
            source: "HistoryDetailsItem.qml"             
        }
    ]
    
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
                    tabDelegate.source = "HistoryListView.qml"
                }
            }
        }
        
        Container {
            layout: DockLayout {
            
            }
            layoutProperties: StackLayoutProperties {
                spaceQuota: 3
            }
        }
        
        TopBarButton {
            imageSource: "asset:///images/contacts/contact_add.png"
            
            gestureHandlers: TapHandler {
                onTapped: {
                    contactEditorModel.setNextEditSipAddress(historyListModel.historyModel.sipUri);
                    tabDelegate.source = "../contacts/ContactsListView.qml"
                }
            }
        }
    }
    
    ScrollView {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            horizontalAlignment: HorizontalAlignment.Fill
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
                    imageSource: historyListModel.historyModel.photo
                    horizontalAlignment: HorizontalAlignment.Center
                }
            }
            
            Container {
                layout: DockLayout {
                    
                }
                horizontalAlignment: HorizontalAlignment.Center

                Label {
                    text: historyListModel.historyModel.displayName
                    horizontalAlignment: HorizontalAlignment.Center
                    textStyle.fontSize: FontSize.XLarge
                    textStyle.color: colors.colorC
                    textStyle.base: titilliumWeb.style
                }

                Container {
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Top
                    topPadding: ui.sdu(8)
            
                    Label {
                        text: historyListModel.historyModel.sipUri
                        horizontalAlignment: HorizontalAlignment.Center
                        textStyle.color: colors.colorA
                        textStyle.base: titilliumWeb.style
                    }
                }
            }
            
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                horizontalAlignment: HorizontalAlignment.Center
                bottomPadding: ui.sdu(2)
                topPadding: ui.sdu(2)
                
                ImageButton {
                    verticalAlignment: VerticalAlignment.Center
                    defaultImageSource: "asset:///images/call_start_body_default.png"
                    pressedImageSource: "asset:///images/call_start_body_over.png"
                    disabledImageSource: "asset:///images/call_start_body_disabled.png"

                    onClicked: {
                        newOutgoingCallOrCallTransfer(historyListModel.historyModel.linphoneAddress);
                    }
                }
                
                ImageButton {
                    verticalAlignment: VerticalAlignment.Center
                    defaultImageSource: "asset:///images/chat_start_body_default.png"
                    pressedImageSource: "asset:///images/chat_start_body_over.png"
                    disabledImageSource: "asset:///images/chat_start_body_disabled.png"

                    onClicked: {
                        chatListModel.viewConversation(historyListModel.historyModel.linphoneAddress);
                        chatListModel.chatModel.setPreviousPage("../history/HistoryDetailsView.qml");
                        tabDelegate.source = "../chat/ChatConversationView.qml";
                    }
                }
            }
            
            CustomDivider {
                
            }
            
            Container {
                layout: DockLayout {
                    
                }
                horizontalAlignment: HorizontalAlignment.Fill
                
                Label {
                    text: qsTr("CALLS") + Retranslate.onLanguageChanged
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Top
                    textStyle.fontSize: FontSize.Small
                    textStyle.color: colors.colorD
                    textStyle.base: titilliumWeb.style
                }
                
                Container {
                    id: callsContainer
                    verticalAlignment: VerticalAlignment.Bottom
                    horizontalAlignment: HorizontalAlignment.Center
                    topPadding: ui.sdu(6)
                }
            }
        }
    }
    
    function fillHistoryDetails() {
        callsContainer.removeAll();
        
        for (var log in historyListModel.historyModel.logs) {
            var item = historyDetailsItem.createObject();
            item.text = log;
            item.image = historyListModel.historyModel.logs[log];
            callsContainer.insert(0, item);
        }
    }
    
    onCreationCompleted: {
        fillHistoryDetails();
    }
}