/*
 * InCallContactAvatar.qml
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
    property alias imageSource: avatar.imageSource
    property alias filterColor: avatar.filterColor
    
    layout: DockLayout {
    
    }
    verticalAlignment: VerticalAlignment.Fill
    horizontalAlignment: HorizontalAlignment.Fill
    
    ContactAvatar {
        id: avatar
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
        maxWidth: ui.sdu(41)
        maxHeight: ui.sdu(41)
        minWidth: ui.sdu(41)
        minHeight: ui.sdu(41)
    }
    
    ImageView {
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
        scalingMethod: ScalingMethod.AspectFill
        imageSource: "asset:///images/call/avatar_mask_border.png"
        maxWidth: ui.sdu(41)
        maxHeight: ui.sdu(41)
        minWidth: ui.sdu(41)
        minHeight: ui.sdu(41)
    }
}
