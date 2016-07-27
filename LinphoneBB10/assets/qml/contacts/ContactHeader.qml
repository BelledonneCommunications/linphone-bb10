/*
 * ContactHeader.qml
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
    property alias displayName : contactName.text
    property alias photo: contactPhoto.imageSource
    
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }
    preferredWidth: 1440
    
    background: Qt.colors.colorH
    topPadding: ui.sdu(2)
    bottomPadding: ui.sdu(2)
    
    ContactAvatar {
        id: contactPhoto
        maxHeight: ui.sdu(20)
        maxWidth: ui.sdu(20)
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Top
    }
    
    Container {
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Top
        
        Label {
            id: contactName
            textStyle.color: Qt.colors.colorC
            textStyle.fontSize: FontSize.XLarge
            textStyle.base: Qt.titilliumWeb.style
        }
    }
}
