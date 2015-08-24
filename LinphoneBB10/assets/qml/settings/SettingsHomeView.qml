/*
 * SettingsHomeView.qml
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

import "../custom_controls"

ScrollView {
    verticalAlignment: VerticalAlignment.Fill
    horizontalAlignment: HorizontalAlignment.Fill

    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        leftPadding: ui.sdu(1)
        rightPadding: ui.sdu(1)

        SettingsToggle {
            text: qsTr("Debug") + Retranslate.onLanguageChanged
            checked: settingsModel.debugEnabled
            horizontalAlignment: HorizontalAlignment.Fill

            onToggled: {
                settingsModel.debugEnabled = checked;
            }
        }
        
        SettingsHeader {
            text: qsTr("AUDIO") + Retranslate.onLanguageChanged
            visible: false
            
            gestureHandlers: TapHandler {
                onTapped: {
                    audioSettings.visible = !audioSettings.visible
                }
            }
        }
        
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            horizontalAlignment: HorizontalAlignment.Fill
            id: audioSettings
            visible: false
        }
        
        SettingsHeader {
            text: qsTr("VIDEO") + Retranslate.onLanguageChanged
            
            gestureHandlers: TapHandler {
                onTapped: {
                    videoSettings.visible = !videoSettings.visible
                }
            }
        }
        
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            horizontalAlignment: HorizontalAlignment.Fill
            id: videoSettings
            
            SettingsToggle {
                text: qsTr("Enabled") + Retranslate.onLanguageChanged
                checked: settingsModel.videoEnabled
                horizontalAlignment: HorizontalAlignment.Fill
                
                onToggled: {
                    settingsModel.videoEnabled = checked;
                }
            }
        }
        
        SettingsHeader {
            text: qsTr("SECURITY") + Retranslate.onLanguageChanged
            
            gestureHandlers: TapHandler {
                onTapped: {
                    securitySettings.visible = !securitySettings.visible
                }
            }
        }
        
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            horizontalAlignment: HorizontalAlignment.Fill
            id: securitySettings
            
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
                    },
                    Option {
                        text: "ZRTP"
                        value: 2
                    },
                    Option {
                        text: "DTLS"
                        value: 3
                        enabled: false
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
        
        SettingsHeader {
            text: qsTr("NETWORK") + Retranslate.onLanguageChanged
            visible: false
            
            gestureHandlers: TapHandler {
                onTapped: {
                    networkSettings.visible = !networkSettings.visible
                }
            }
        }
        
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            horizontalAlignment: HorizontalAlignment.Fill
            id: networkSettings
            visible: false
        }
        
        SettingsHeader {
            text: qsTr("ADVANCED") + Retranslate.onLanguageChanged
            visible: false
            
            gestureHandlers: TapHandler {
                onTapped: {
                    advancedSettings.visible = !advancedSettings.visible
                }
            }
        }
        
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            horizontalAlignment: HorizontalAlignment.Fill
            id: advancedSettings
            visible: false
        }
    }
}