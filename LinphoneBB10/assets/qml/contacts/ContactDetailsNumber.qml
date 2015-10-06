/*
 * ContactDetailsNumber.qml
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
    property alias label : label.text
    property alias number: number.text
    
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }
    leftPadding: ui.sdu(1)
    rightPadding: ui.sdu(1)
    
    CustomListDivider {
        
    }
    
    Container {
        layout: DockLayout {
            
        }
        background: colors.colorH
        topPadding: ui.sdu(2)
        bottomPadding: ui.sdu(2)
        leftPadding: ui.sdu(2)
        rightPadding: ui.sdu(2)
        horizontalAlignment: HorizontalAlignment.Fill
        
        Label {
            id: label
            textStyle.color: colors.colorD
            textStyle.fontSize: FontSize.Small
            textStyle.base: titilliumWeb.style
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Top
        }
        
        Container {
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Top
            topPadding: ui.sdu(5)
            
            Label {
                id: number
                textStyle.color: colors.colorC
                textStyle.fontSize: FontSize.Large
                textStyle.base: titilliumWeb.style
            }
        }
        
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            topPadding: ui.sdu(15)
            
            ImageButton {
                verticalAlignment: VerticalAlignment.Center
                defaultImageSource: "asset:///images/call_start_body_default.png"
                pressedImageSource: "asset:///images/call_start_body_over.png"
                disabledImageSource: "asset:///images/call_start_body_disabled.png"
                
                onClicked: {
                    newOutgoingCallOrCallTransfer(number.text);
                }
            }
            
            ImageButton {
                verticalAlignment: VerticalAlignment.Center
                defaultImageSource: "asset:///images/chat_start_body_default.png"
                pressedImageSource: "asset:///images/chat_start_body_over.png"
                disabledImageSource: "asset:///images/chat_start_body_disabled.png"
                
                onClicked: {
                    chatListModel.viewConversation(number.text);
                    chatListModel.chatModel.setPreviousPage("../contacts/ContactDetailsView.qml");
                    tabDelegate.source = "../chat/ChatConversationView.qml";
                }
            }
        }
    }
}
