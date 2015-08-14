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
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
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
        }
        
        NumpadDigit {
            digitValue: "2"
            imageSource: "asset:///images/dialer/numpad_2.png"
        }
        
        NumpadDigit {
            digitValue: "3"
            imageSource: "asset:///images/dialer/numpad_3.png"
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
        }
        
        NumpadDigit {
            digitValue: "5"
            imageSource: "asset:///images/dialer/numpad_5.png"
        }
        
        NumpadDigit {
            digitValue: "6"
            imageSource: "asset:///images/dialer/numpad_6.png"
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
        }
        
        NumpadDigit {
            digitValue: "8"
            imageSource: "asset:///images/dialer/numpad_8.png"
        }
        
        NumpadDigit {
            digitValue: "9"
            imageSource: "asset:///images/dialer/numpad_9.png"
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
        }
        
        NumpadDigit {
            digitValue: "0"
            longPressValue: "+"
            imageSource: "asset:///images/dialer/numpad_0.png"
        }
        
        NumpadDigit {
            digitValue: "#"
            imageSource: "asset:///images/dialer/numpad_hash.png"
        }
    }
}
