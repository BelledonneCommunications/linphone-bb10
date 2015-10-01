/*
 * SettingsAccountView.qml
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

import ".."
import "../custom_controls"

Page {
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }
        
        StatusBar {
            menuEnabled: false
        }
        
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            minHeight: ui.sdu(15)
            background: colors.colorF
            
            TopBarButton {
                imageSource: "asset:///images/contacts/delete.png"
                
                gestureHandlers: TapHandler {
                    onTapped: {
                        settingsModel.accountSettingsModel.deleteAccount();
                        navigationPane.pop();
                    }
                }
            }
            
            Container {
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 3
                }
                verticalAlignment: VerticalAlignment.Center
                
                Label {
                    text: qsTr("ACCOUNT") + Retranslate.onLanguageChanged
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    textStyle.color: colors.colorA
                    textStyle.fontWeight: FontWeight.Bold
                    textStyle.fontSize: FontSize.XLarge
                    textStyle.base: titilliumWeb.style
                }
            }
            
            TopBarButton {
                imageSource: "asset:///images/assistant/dialer_back.png"
                
                gestureHandlers: TapHandler {
                    onTapped: {
                        navigationPane.pop();
                    }
                }
            }
        }
        
        Container {
            layout: DockLayout {
            
            }
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            
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
                    
                    SettingsSubHeader {
                        text: qsTr("SIP account") + Retranslate.onLanguageChanged
                    }
                    
                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        horizontalAlignment: HorizontalAlignment.Fill
                        
                        Label {
                            text: qsTr("Username") + Retranslate.onLanguageChanged
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
                            verticalAlignment: VerticalAlignment.Center
                            input.keyLayout: KeyLayout.Alphanumeric
                            inputMode: TextFieldInputMode.Default
                            text: settingsModel.accountSettingsModel.username
                            
                            onTextChanged: {
                                settingsModel.accountSettingsModel.username = text
                            }
                        }
                    }
                    
                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        horizontalAlignment: HorizontalAlignment.Fill
                        
                        Label {
                            text: qsTr("Auth userid") + Retranslate.onLanguageChanged
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
                            verticalAlignment: VerticalAlignment.Center
                            input.keyLayout: KeyLayout.Alphanumeric
                            inputMode: TextFieldInputMode.Default
                            text: settingsModel.accountSettingsModel.authid
                            
                            onTextChanged: {
                                settingsModel.accountSettingsModel.authid = text
                            }
                        }
                    }
                    
                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        horizontalAlignment: HorizontalAlignment.Fill
                        
                        Label {
                            text: qsTr("Password") + Retranslate.onLanguageChanged
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
                            verticalAlignment: VerticalAlignment.Center
                            input.keyLayout: KeyLayout.Alphanumeric
                            inputMode: TextFieldInputMode.Password
                        }
                    }
                    
                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        horizontalAlignment: HorizontalAlignment.Fill
                        
                        Label {
                            text: qsTr("Domain") + Retranslate.onLanguageChanged
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
                            verticalAlignment: VerticalAlignment.Center
                            input.keyLayout: KeyLayout.EmailAddress
                            inputMode: TextFieldInputMode.EmailAddress
                            text: settingsModel.accountSettingsModel.domain
                            
                            onTextChanged: {
                                settingsModel.accountSettingsModel.domain = text
                            }
                        }
                    }
                    
                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        horizontalAlignment: HorizontalAlignment.Fill
                        
                        Label {
                            text: qsTr("Display Name") + Retranslate.onLanguageChanged
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
                            verticalAlignment: VerticalAlignment.Center
                            input.keyLayout: KeyLayout.Contact
                            inputMode: TextFieldInputMode.Text
                            text: settingsModel.accountSettingsModel.displayName
                            
                            onTextChanged: {
                                settingsModel.accountSettingsModel.displayName = text
                            }
                        }
                    }
                    
                    SettingsSubHeader {
                        text: qsTr("Advanced") + Retranslate.onLanguageChanged
                    }
                    
                    
                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        horizontalAlignment: HorizontalAlignment.Fill
                        
                        Label {
                            text: qsTr("Transport") + Retranslate.onLanguageChanged
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 1
                            }
                            horizontalAlignment: HorizontalAlignment.Left
                            verticalAlignment: VerticalAlignment.Center
                            textStyle.base: titilliumWeb.style
                        
                        }
                        
                        SegmentedControl {
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 2
                            }
                            selectedIndex: settingsModel.accountSettingsModel.transportIndex
                            Option {
                                text: "UDP"
                                value: "udp"
                            }
                            Option {
                                text: "TCP"
                                value: "tcp"
                            }
                            Option {
                                text: "TLS"
                                value: "tls"
                            }
                        }
                    }
                    
                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.LeftToRight
                        }
                        horizontalAlignment: HorizontalAlignment.Fill
                        
                        Label {
                            text: qsTr("Proxy") + Retranslate.onLanguageChanged
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
                            verticalAlignment: VerticalAlignment.Center
                            input.keyLayout: KeyLayout.EmailAddress
                            inputMode: TextFieldInputMode.EmailAddress
                            text: settingsModel.accountSettingsModel.proxy
                        }
                    }
                    
                    SettingsToggle {
                        text: qsTr("Outbound proxy") + Retranslate.onLanguageChanged
                        checked: settingsModel.accountSettingsModel.outboundProxy
                    }
                    
                    SettingsToggle {
                        text: qsTr("AVPF") + Retranslate.onLanguageChanged
                        checked: settingsModel.accountSettingsModel.avpf
                    }
                    
                    SettingsSubHeader {
                        text: qsTr("Manage") + Retranslate.onLanguageChanged
                    }
                    
                    SettingsToggle {
                        text: qsTr("Use as default") + Retranslate.onLanguageChanged
                        checked: settingsModel.accountSettingsModel.defaultProxy
                        enabled: !settingsModel.accountSettingsModel.defaultProxy
                        
                        onToggled: {
                            settingsModel.accountSettingsModel.defaultProxy = checked
                        }
                    }
                }
            }
        }
    }
}
