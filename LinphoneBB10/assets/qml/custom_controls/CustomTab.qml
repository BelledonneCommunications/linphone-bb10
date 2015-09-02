/*
 * CustomTab.qml
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

Container {
    property alias imageSource: tabImage.imageSource
    property alias selected: selection.visible
    property int badgeValue: 0
    
    background: colors.colorC
    
    layout: DockLayout {
        
    }
    layoutProperties: StackLayoutProperties {
        spaceQuota: 1
    }
    
    Container {
        layout: DockLayout {
            
        }
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
        
        ImageView {
            id: tabImage
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
        }
        
        Container {
            layout: DockLayout {
            
            }
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            visible: badgeValue > 0
            rightPadding: ui.sdu(7)
            bottomPadding: ui.sdu(5)
            
            ImageView {
                imageSource: "asset:///images/history_chat_indicator.png"
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
            }
            
            Label {
                text: badgeValue
                textStyle.base: titilliumWeb.style
                textStyle.fontSize: FontSize.XXSmall
                textStyle.color: colors.colorH
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
            }
        }
    }
    
    Container {
        id: selection
        visible: false
        maxHeight: ui.sdu(1)
        minHeight: ui.sdu(1)
        background: colors.colorA
        verticalAlignment: VerticalAlignment.Bottom
        horizontalAlignment: HorizontalAlignment.Fill
    }
}
