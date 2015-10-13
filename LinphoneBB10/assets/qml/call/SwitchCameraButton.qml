/*
 * SwitchCameraButton.qml
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
    leftPadding: ui.sdu(5)
    topPadding: ui.sdu(21)
    verticalAlignment: VerticalAlignment.Top
    horizontalAlignment: HorizontalAlignment.Left
    
    ImageButton {
        defaultImageSource: "asset:///images/call/camera_switch_default.png"
        pressedImageSource: "asset:///images/call/camera_switch_over.png"
        disabledImageSource: "asset:///images/call/camera_switch_disabled.png"
        
        onClicked: {
            inCallModel.switchCamera();
        }
    }
}