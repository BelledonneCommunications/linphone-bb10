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
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */

import bb.cascades 1.4

import "../custom_controls"

Container {
    property string displayName
    property string callTime
    property string photo

    layout: DockLayout {
        
    }
    maxHeight: ui.sdu(15)
    
    Container {
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        background: colors.colorA
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
            imageSource: photo
            filterColor: colors.colorA50
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            maxWidth: ui.sdu(13)
            maxHeight: ui.sdu(13)
        }
    
        Label {
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            text: displayName
            verticalAlignment: VerticalAlignment.Center
            textStyle.fontSize: FontSize.XLarge
            textStyle.color: colors.colorH
            textStyle.base: titilliumWeb.style
        }
    
        Label {
            text: callTime
            verticalAlignment: VerticalAlignment.Center
            textStyle.color: colors.colorH
            textStyle.base: titilliumWeb.style
        }
    
        CustomImageToggle {
            maxWidth: ui.sdu(10)
            maxHeight: ui.sdu(10)
            imageSource: "asset:///images/call/pause_big_default.png"
            selectedImageSource: "asset:///images/call/pause_big_over_selected.png"
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Right
            selected: true
    
            gestureHandlers: TapHandler {
                onTapped: {
                    
                }
            }
        }
    }
}
