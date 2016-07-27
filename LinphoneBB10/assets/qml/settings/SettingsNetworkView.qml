/*
 * SettingsNetworkView.qml
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
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }
    horizontalAlignment: HorizontalAlignment.Fill
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        horizontalAlignment: HorizontalAlignment.Fill
        
        Label {
            text: qsTr("STUN server") + Retranslate.onLanguageChanged
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            horizontalAlignment: HorizontalAlignment.Left
            verticalAlignment: VerticalAlignment.Center
            textStyle.base: titilliumWeb.style
            
        }
        
        CustomTextField {
            layoutProperties: StackLayoutProperties {
                spaceQuota: 2
            }
            text: settingsModel.stunServer
            verticalAlignment: VerticalAlignment.Center
            input.keyLayout: KeyLayout.EmailAddress
            inputMode: TextFieldInputMode.EmailAddress
            
            onTextChanged: {
                settingsModel.stunServer = text
            }
        }
    }
    
    SettingsToggle {
        text: qsTr("Enable ICE") + Retranslate.onLanguageChanged
        checked: settingsModel.iceEnabled
        horizontalAlignment: HorizontalAlignment.Fill
        enabled: settingsModel.stunServer.length > 0
        
        onToggled: {
            settingsModel.iceEnabled = checked;
        }
    }
    
    SettingsToggle {
        text: qsTr("Use random ports (instead of 5060/5061)") + Retranslate.onLanguageChanged
        checked: settingsModel.randomPorts
        horizontalAlignment: HorizontalAlignment.Fill
        
        onToggled: {
            settingsModel.randomPorts = checked;
        }
    }
}