/*
 * CustomTextField.qml
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
    property alias text: textfield.text
    property alias inputMode: textfield.inputMode
    property alias input: textfield.input
    property alias textStyle: textfield.textStyle
    property alias hintText: textfield.hintText
    property alias errorText: error.text
    
    signal textFieldChanging(string text)
    signal textFieldChanged(string text)
    
    layout: DockLayout {
        
    }
    
    Container {
        layout: DockLayout {
            
        }
        
        ImageView {
            visible: errorText.length == 0
            imageSource: "asset:///images/resizable_textfield.amd"
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
        }
        
        ImageView {
            visible: errorText.length > 0
            imageSource: "asset:///images/resizable_textfield_error.amd"
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
        }
        
        TextField {
            id: textfield
            backgroundVisible: false
            hintText: ""
            textStyle.base: titilliumWeb.style
            textStyle.color: colors.colorC
            textStyle.fontSize: FontSize.Large
            
            onTextChanging: {
                textFieldChanging(text);
            }
            
            onTextChanged: {
                textFieldChanged(text);
            }
        }
    }
    
    Container {
        topPadding: ui.sdu(8)
        visible: errorText.length > 0
        
        Label {
            id: error
            textStyle.color: colors.colorM
            textStyle.base: titilliumWeb.style
            textStyle.fontSize: FontSize.XSmall
        }
    }
}
