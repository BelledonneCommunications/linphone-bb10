/*
 * CallAudioView.qml
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
    layout: DockLayout {
    
    }
    layoutProperties: StackLayoutProperties {
        spaceQuota: 1
    }
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill
    
    Container {
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Fill
        
        Container {
            layout: DockLayout {
            
            }
            horizontalAlignment: HorizontalAlignment.Fill
            
            InCallContactAvatar {
                imageSource: inCallModel.photo
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                maxWidth: ui.sdu(41)
                maxHeight: ui.sdu(41)
            }
            
            CustomImageToggle {
                imageSource: "asset:///images/call/pause_big_default.png"
                selectedImageSource: "asset:///images/call/pause_big_over_selected.png"
                verticalAlignment: VerticalAlignment.Bottom
                horizontalAlignment: HorizontalAlignment.Center
                selected: inCallModel.isPaused
                leftPadding: ui.sdu(50)
                topPadding: ui.sdu(20)
                
                gestureHandlers: TapHandler {
                    onTapped: {
                        inCallModel.togglePause();
                    }
                }
            }
        }
        
        Label {
            text: inCallModel.displayName
            horizontalAlignment: HorizontalAlignment.Center
            textStyle.fontSize: FontSize.XLarge
            textStyle.color: colors.colorC
            textStyle.base: titilliumWeb.style
        }
        
        Label {
            text: inCallModel.callTime
            horizontalAlignment: HorizontalAlignment.Center
            textStyle.color: colors.colorA
            textStyle.base: titilliumWeb.style
        }
    }
}