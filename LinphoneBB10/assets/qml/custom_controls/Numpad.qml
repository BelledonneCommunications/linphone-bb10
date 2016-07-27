/*
 * Numpad.qml
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
    horizontalAlignment: HorizontalAlignment.Center
    verticalAlignment: VerticalAlignment.Center
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
        
        NumpadDigit {
            digitValue: "1"
            imageSource: "asset:///images/dialer/numpad_1.png"
            pressedImageSource: "asset:///images/dialer/numpad_1_over.png"
        }
        
        NumpadDigit {
            digitValue: "2"
            imageSource: "asset:///images/dialer/numpad_2.png"
            pressedImageSource: "asset:///images/dialer/numpad_2_over.png"
        }
        
        NumpadDigit {
            digitValue: "3"
            imageSource: "asset:///images/dialer/numpad_3.png"
            pressedImageSource: "asset:///images/dialer/numpad_3_over.png"
        }
    }
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
        
        NumpadDigit {
            digitValue: "4"
            imageSource: "asset:///images/dialer/numpad_4.png"
            pressedImageSource: "asset:///images/dialer/numpad_4_over.png"
        }
        
        NumpadDigit {
            digitValue: "5"
            imageSource: "asset:///images/dialer/numpad_5.png"
            pressedImageSource: "asset:///images/dialer/numpad_5_over.png"
        }
        
        NumpadDigit {
            digitValue: "6"
            imageSource: "asset:///images/dialer/numpad_6.png"
            pressedImageSource: "asset:///images/dialer/numpad_6_over.png"
        }
    }
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
        
        NumpadDigit {
            digitValue: "7"
            imageSource: "asset:///images/dialer/numpad_7.png"
            pressedImageSource: "asset:///images/dialer/numpad_7_over.png"
        }
        
        NumpadDigit {
            digitValue: "8"
            imageSource: "asset:///images/dialer/numpad_8.png"
            pressedImageSource: "asset:///images/dialer/numpad_8_over.png"
        }
        
        NumpadDigit {
            digitValue: "9"
            imageSource: "asset:///images/dialer/numpad_9.png"
            pressedImageSource: "asset:///images/dialer/numpad_9_over.png"
        }
    }
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
        
        NumpadDigit {
            digitValue: "*"
            imageSource: "asset:///images/dialer/numpad_star.png"
            pressedImageSource: "asset:///images/dialer/numpad_star_over.png"
        }
        
        NumpadDigit {
            digitValue: "0"
            longPressValue: "+"
            imageSource: "asset:///images/dialer/numpad_0.png"
            pressedImageSource: "asset:///images/dialer/numpad_0_over.png"
        }
        
        NumpadDigit {
            digitValue: "#"
            imageSource: "asset:///images/dialer/numpad_hash.png"
            pressedImageSource: "asset:///images/dialer/numpad_hash_over.png"
        }
    }
}
