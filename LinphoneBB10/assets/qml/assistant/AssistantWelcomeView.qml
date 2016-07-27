/*
 * AssistantWelcomeView.qml
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

ScrollView {
    verticalAlignment: VerticalAlignment.Fill
    horizontalAlignment: HorizontalAlignment.Fill
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }
        horizontalAlignment: HorizontalAlignment.Fill
    
        Label {
            text: qsTr("WELCOME") + Retranslate.onLanguageChanged
            textStyle.color: colors.colorC
            textStyle.base: titilliumWeb.style
            textStyle.fontSize: FontSize.Large
            horizontalAlignment: HorizontalAlignment.Center
        }
    
        Container {
            topPadding: ui.sdu(4)
            horizontalAlignment: HorizontalAlignment.Center
    
            AssistantButton {
                text: qsTr("CREATE A LINPHONE ACCOUNT") + Retranslate.onLanguageChanged
                minW: ui.sdu(70)
    
                onClicked: {
                    assistantModel.setPreviousPage("AssistantWelcomeView.qml");
                    assistantDelegate.source = "AssistantCreateAccountView.qml"
                }
            }
        }
    
        Container {
            topPadding: ui.sdu(8)
            horizontalAlignment: HorizontalAlignment.Center
    
            AssistantButton {
                text: qsTr("I HAVE A LINPHONE ACCOUNT") + Retranslate.onLanguageChanged
                minW: ui.sdu(70)
    
                onClicked: {
                    assistantModel.setPreviousPage("AssistantWelcomeView.qml");
                    assistantDelegate.source = "AssistantLinphoneLoginView.qml"
                }
            }
        }
    
        Container {
            topPadding: ui.sdu(8)
            horizontalAlignment: HorizontalAlignment.Center
    
            AssistantButton {
                text: qsTr("I HAVE A SIP ACCOUNT") + Retranslate.onLanguageChanged
                minW: ui.sdu(70)
    
                onClicked: {
                    assistantModel.setPreviousPage("AssistantWelcomeView.qml");
                    assistantDelegate.source = "AssistantLoginView.qml"
                }
            }
        }
    
        Container {
            topPadding: ui.sdu(8)
            horizontalAlignment: HorizontalAlignment.Center
    
            AssistantButton {
                text: qsTr("REMOTE PROVISIONING") + Retranslate.onLanguageChanged
                minW: ui.sdu(70)
    
                onClicked: {
                    assistantModel.setPreviousPage("AssistantWelcomeView.qml");
                    assistantDelegate.source = "AssistantRemoteProvisioningView.qml"
                }
            }
        }
    }
}
