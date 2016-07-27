/*
 * ConferenceCall.qml
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
    minHeight: ui.sdu(18)
    maxHeight: ui.sdu(18)
    background: Qt.colors.colorH
    
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
            filterColor: Qt.colors.colorH
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            maxWidth: ui.sdu(13)
            maxHeight: ui.sdu(13)
        }
        
        Container {
            layout: DockLayout {
                
            }
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            leftPadding: ui.sdu(2)
            verticalAlignment: VerticalAlignment.Center
            
            Label {
                text: ListItemData.displayName
                horizontalAlignment: HorizontalAlignment.Left
                verticalAlignment: VerticalAlignment.Top
                textStyle.fontSize: FontSize.XLarge
                textStyle.color: Qt.colors.colorC
                textStyle.base: Qt.titilliumWeb.style
            }
            
            Container {
                horizontalAlignment: HorizontalAlignment.Left
                verticalAlignment: VerticalAlignment.Bottom
                topPadding: ui.sdu(8)
                
                Label {
                    text: ListItemData.callTime
                    verticalAlignment: VerticalAlignment.Center
                    textStyle.color: Qt.colors.colorA
                    textStyle.base: Qt.titilliumWeb.style
                }
            }
        }
        
        ImageButton {
            maxWidth: ui.sdu(10)
            maxHeight: ui.sdu(10)
            defaultImageSource: "asset:///images/call/conference_exit_default.png"
            pressedImageSource: "asset:///images/call/conference_exit_over.png"
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Right
            
            onClicked: {
                itemRoot.ListItem.view.ejectFromConference(ListItemData.call);
            }
        }
    }
    
    CustomListDivider {
        verticalAlignment: VerticalAlignment.Bottom
    }
}