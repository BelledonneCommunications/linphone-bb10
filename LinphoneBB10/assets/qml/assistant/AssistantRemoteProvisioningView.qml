/*
 * AssistantRemoteProvisioningView.qml
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
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }
        
        Label {
            text: qsTr("REMOTE PROVISIONING") + Retranslate.onLanguageChanged
            textStyle.color: colors.colorC
            textStyle.base: titilliumWeb.style
            textStyle.fontSize: FontSize.Large
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Top
        }
        
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            topPadding: ui.sdu(4)
            leftPadding: ui.sdu(2)
            rightPadding: ui.sdu(2)
            horizontalAlignment: HorizontalAlignment.Center
            
            Container {
                layout: DockLayout {
                
                }
                
                Label {
                    verticalAlignment: VerticalAlignment.Top
                    text: qsTr("PROVISIONING URL") + Retranslate.onLanguageChanged
                    textStyle.color: colors.colorE
                    textStyle.fontSize: FontSize.Small
                    textStyle.base: titilliumWeb.style
                }
                
                CustomTextField {
                    id: remoteProvisioningUrl
                    topPadding: ui.sdu(6)
                    verticalAlignment: VerticalAlignment.Bottom
                    input.keyLayout: KeyLayout.Url
                    inputMode: TextFieldInputMode.Url
                    textStyle.textAlign: TextAlign.Center
                    text: assistantModel.remoteProvisioningUrl
                }
            }
            
            AssistantButton {
                topPadding: ui.sdu(4)
                text: qsTr("APPLY") + Retranslate.onLanguageChanged
                horizontalAlignment: HorizontalAlignment.Center
                
                onClicked: {
                    if (remoteProvisioningUrl.text.length == 0) {
                        showDialog(qsTr("Please fill in an URL to your configuration file") + Retranslate.onLanguageChanged)
                    } else {
                        var success = assistantModel.remoteProvisioning(remoteProvisioningUrl.text)
                        if (success) {
                            navigationPane.pop();
                        }
                    }
                }
            }
        }
    }
}
