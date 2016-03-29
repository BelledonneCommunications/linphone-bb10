/*
 * AboutView.qml
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
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        StatusBar {
            menuEnabled: false
        }
        
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            minHeight: ui.sdu(15)
            background: colors.colorF
            
            Container {
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
            }
            
            Container {
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 3
                }
                verticalAlignment: VerticalAlignment.Center
                
                Label {
                    text: qsTr("ABOUT") + Retranslate.onLanguageChanged
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
        
        ScrollView {
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
            
            Container {
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Fill
                
                Label {
                    text: qsTr("Linphone (rfc 3261) compatible phone\r\nunder GNU Public License V2") + Retranslate.onLanguageChanged
                    textStyle.base: titilliumWeb.style
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    textStyle.textAlign: TextAlign.Center
                    multiline: true
                }
                
                Label {
                    text: qsTr("<html><a href=\"https://www.linphone.org\">Linphone.org website</a></html>") + Retranslate.onLanguageChanged
                    textStyle.base: titilliumWeb.style
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    multiline: true
                }
                
                Label {
                    text: qsTr("<html><a href=\"https://www.linphone.org/user-guide.html\">Instructions</a></html>") + Retranslate.onLanguageChanged
                    textStyle.base: titilliumWeb.style
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    multiline: true
                }
                
                Label {
                    text: qsTr("© 2016 Belledonne Communications") + Retranslate.onLanguageChanged
                    textStyle.base: titilliumWeb.style
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    multiline: true
                }
                
                Divider {
                    
                }
                
                Label {
                    text: qsTr("If you encounter an issue, please provide us the following values along with a description of the problem.")
                    textStyle.base: titilliumWeb.style
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    textStyle.textAlign: TextAlign.Center
                    multiline: true
                }
                
                Label {
                    text: linphoneManager.appVersion
                    textStyle.base: titilliumWeb.style
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                }
                
                Label {
                    text: linphoneManager.coreVersion
                    textStyle.base: titilliumWeb.style
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                }
                
                Label {
                    text: linphoneManager.blackberryVersion
                    textStyle.base: titilliumWeb.style
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                }
            }
        }
    }
}
