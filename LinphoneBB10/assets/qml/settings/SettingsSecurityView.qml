/*
 * SettingsSecurityView.qml
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
    
    DropDown {
        title: qsTr("Media Encryption") + Retranslate.onLanguageChanged
        selectedIndex: settingsModel.mediaEncryption
        options: [
            Option {
                text: qsTr("None") + Retranslate.onLanguageChanged
                value: 0
            },
            Option {
                text: "SRTP"
                value: 1
                enabled: settingsModel.isSrtpSupported
            },
            Option {
                text: "ZRTP"
                value: 2
                enabled: settingsModel.isZrtpSupported
            },
            Option {
                text: "DTLS"
                value: 3
                enabled: settingsModel.isDtlsSupported
            }
        ]
        onSelectedIndexChanged: {
            settingsModel.mediaEncryption = selectedIndex
        }
    }
    
    SettingsToggle {
        text: qsTr("Media encryption mandatory") + Retranslate.onLanguageChanged
        checked: settingsModel.mediaEncryptionMandatory
        horizontalAlignment: HorizontalAlignment.Fill
        
        onToggled: {
            settingsModel.mediaEncryptionMandatory = checked;
        }
    }
}