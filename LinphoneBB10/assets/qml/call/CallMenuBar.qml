/*
 * CallMenuBar.qml
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
        orientation: LayoutOrientation.LeftToRight
    }
    minHeight: ui.sdu(15)
    visible: inCallModel.areControlsVisible
    
    Container {
        layout: DockLayout {
        
        }
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Center
        background: colors.colorC
        
        gestureHandlers: TapHandler {
            onTapped: {
                numpad.visible = ! numpad.visible
                numpadToggle.selected = numpad.visible
            }
        }
        
        CustomImageToggle {
            id: numpadToggle
            imageSource: "asset:///images/footer_dialer.png"
            selectedImageSource: "asset:///images/call/dialer_alt_back.png"
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
        }
    }
    
    Container {
        layout: DockLayout {
        
        }
        layoutProperties: StackLayoutProperties {
            spaceQuota: 2
        }
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Center
        background: colors.colorD
        
        onTouch: {
            if (event.isDown() || event.isMove()) {
                background = colors.colorI
            } else if (event.isUp() || event.isCancel()) {
                background = colors.colorD
                if (event.isUp()) {
                    inCallModel.hangUp()
                }
            }
        }
        
        onTouchExit: {
            background = colors.colorD
        }
        
        ImageView {
            imageSource: "asset:///images/call/call_hangup.png"
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }
    }
    
    Container {
        layout: DockLayout {
        
        }
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Center
        background: colors.colorC
        
        gestureHandlers: TapHandler {
            onTapped: {
                chatListModel.viewConversation(inCallModel.sipUri);
                tabDelegate.source = "../chat/ChatConversationView.qml"
                inCallView.close();
            }
        }
        
        ImageView {
            imageSource: "asset:///images/footer_chat.png"
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            opacity: enabled ? 1 : 0.2
        }
    }
}