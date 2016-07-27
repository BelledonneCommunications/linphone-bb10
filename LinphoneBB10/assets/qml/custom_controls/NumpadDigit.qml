/*
 * NumpadDigit.qml
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
    property string digitValue
    property string longPressValue
    property alias imageSource: digit.imageSource
    property alias pressedImageSource: pressedDigit.imageSource
    
    layoutProperties: StackLayoutProperties {
        spaceQuota: 1
    }

    gestureHandlers: [
        TapHandler {
            onTapped: {
                inputNumber.text += digitValue
            }
        },
        LongPressHandler {
            onLongPressed: {
                inputNumber.text += longPressValue
            }
        }
    ]
    
    onTouch: {
        if (event.isDown()) {
            linphoneManager.playDtmf(digitValue);
            digit.visible = false;
        } else if (event.isUp() || event.isCancel()) {
            linphoneManager.stopDtmf();
            digit.visible = true;
        } else if (event.isMove()) {
            digit.visible = false;
        }
    }
    
    onTouchExit: {
        linphoneManager.stopDtmf();
        digit.visible = true;
    }

    ImageView {
        id: digit
        horizontalAlignment: HorizontalAlignment.Center
        imageSource: "asset:///images/dialer/numpad_1.png"
    }
    
    ImageView {
        id: pressedDigit
        visible: !digit.visible
        horizontalAlignment: HorizontalAlignment.Center
        imageSource: "asset:///images/dialer/numpad_1_over.png"
    }
}
