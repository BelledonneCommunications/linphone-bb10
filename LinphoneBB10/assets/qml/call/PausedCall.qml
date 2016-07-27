/*
 * PausedCall.qml
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
import org.linphone 1.0

import "../custom_controls"

Container {
    layout: DockLayout {
        
    }
    id: itemRoot
    maxHeight: ui.sdu(15)
    minHeight: ui.sdu(15)
    background: Qt.colors.colorH
    
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        background: Qt.colors.colorA
        opacity: 0.5
    }
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        verticalAlignment: VerticalAlignment.Center
        leftPadding: ui.sdu(2)
        rightPadding: ui.sdu(2)
        topPadding: ui.sdu(1)
        bottomPadding: ui.sdu(1)

        ContactAvatar {
            imageSource: ListItemData.photo
            filterColor: Qt.colors.colorA50
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            maxWidth: ui.sdu(13)
            maxHeight: ui.sdu(13)
        }
    
        Label {
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            text: ListItemData.displayName
            verticalAlignment: VerticalAlignment.Center
            textStyle.fontSize: FontSize.XLarge
            textStyle.color: Qt.colors.colorH
            textStyle.base: Qt.titilliumWeb.style
        }
    
        Label {
            text: ListItemData.callTime
            verticalAlignment: VerticalAlignment.Center
            textStyle.color: Qt.colors.colorH
            textStyle.base: Qt.titilliumWeb.style
        }
    
        ImageButton {
            maxWidth: ui.sdu(10)
            maxHeight: ui.sdu(10)
            defaultImageSource: "asset:///images/call/pause_big_over_selected.png"
            pressedImageSource: "asset:///images/call/pause_big_default.png"
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Right
            
            onClicked: {
                itemRoot.ListItem.view.resumeCall(ListItemData.call);
            }
        }
    }
}
