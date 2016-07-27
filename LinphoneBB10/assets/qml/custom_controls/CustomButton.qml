/*
 * CustomButton.qml
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

Container {
    property alias text: label.text
    property alias imageSource: image.imageSource
    property alias pressedImageSource: pressedImage.imageSource
    property alias textStyle: label.textStyle
    
    signal buttonClicked()
    
    layout: DockLayout {
        
    }
    
    ImageView {
        id: image
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
    }
    
    ImageView {
        id: pressedImage
        visible: !image.visible
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
    }
    
    onTouch: {
        if (event.isDown() || event.isMove()) {
            image.visible = false;
        } else if (event.isUp() || event.isCancel()) {
            image.visible = true;
        }
    }
    
    onTouchExit: {
        image.visible = true;
    }
    
    Container {
        leftPadding: ui.sdu(6.5)
        rightPadding: ui.sdu(6.5)
        topPadding: ui.sdu(2)
        bottomPadding: ui.sdu(2)
        horizontalAlignment: HorizontalAlignment.Center

        Label {
            id: label
            textStyle.fontSize: FontSize.Small
        }
    }
    
    gestureHandlers: TapHandler {
        onTapped: {
            buttonClicked();
        }
    }
}
