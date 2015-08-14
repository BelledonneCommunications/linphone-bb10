/*
 * CustomToggleButton.qml
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
    property alias imageSource: image.imageSource
    property alias selectedImageSource: image.selectedImageSource
    property alias selected: selection.visible
    
    layout: DockLayout {
    
    }
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill
    opacity: enabled ? 1 : 0.2
    
    onTouch: {
        if ((event.isDown() || event.isMove()) && enabled) {
            background = colors.colorE
        } else if (event.isUp() || event.isCancel()) {
            background = colors.colorF
        }
    }
    
    onTouchExit: {
        background = colors.colorF
    }
    
    CustomImageToggle {
        id: image
        selected: selection.visible
        imageSource: "asset:///images/hub_icon.png"
        selectedImageSource: "asset:///images/hub_icon.png"
        horizontalAlignment: HorizontalAlignment.Center
        verticalAlignment: VerticalAlignment.Center
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
