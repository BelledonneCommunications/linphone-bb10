/*
 * CustomListTextField.qml
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
    property alias text: textfield.text
    property alias inputMode: textfield.inputMode
    property alias input: textfield.input
    property alias textStyle: textfield.textStyle
    property alias hintText: textfield.hintText
    property alias errorText: error.text
    
    signal textFieldChanging(string text)
    
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
            textStyle.base: Qt.titilliumWeb.style
            textStyle.color: Qt.colors.colorC
            textStyle.fontSize: FontSize.Large
            
            onTextChanging: {
                textFieldChanging(text);
            }
        }
    }
    
    Container {
        topPadding: ui.sdu(8)
        visible: errorText.length > 0
        
        Label {
            id: error
            textStyle.color: Qt.colors.colorM
            textStyle.base: Qt.titilliumWeb.style
            textStyle.fontSize: FontSize.XSmall
        }
    }
}
