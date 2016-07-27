/*
 * AssistantLoginView.qml
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
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }
    
        Label {
            text: qsTr("CONFIGURE SIP ACCOUNT") + Retranslate.onLanguageChanged
            textStyle.color: colors.colorC
            textStyle.base: titilliumWeb.style
            textStyle.fontSize: FontSize.Large
            horizontalAlignment: HorizontalAlignment.Center
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
                    text: qsTr("USERNAME") + Retranslate.onLanguageChanged
                    textStyle.color: colors.colorE
                    textStyle.fontSize: FontSize.Small
                    textStyle.base: titilliumWeb.style
                }
    
                CustomTextField {
                    id: username
                    topPadding: ui.sdu(6)
                    verticalAlignment: VerticalAlignment.Bottom
                    input.keyLayout: KeyLayout.Contact
                    inputMode: TextFieldInputMode.EmailAddress
                    textStyle.textAlign: TextAlign.Center
                }
            }
    
            Container {
                layout: DockLayout {
    
                }
                topPadding: ui.sdu(2)
    
                Label {
                    verticalAlignment: VerticalAlignment.Top
                    text: qsTr("PASSWORD") + Retranslate.onLanguageChanged
                    textStyle.color: colors.colorE
                    textStyle.fontSize: FontSize.Small
                    textStyle.base: titilliumWeb.style
                }
    
                CustomTextField {
                    id: password
                    topPadding: ui.sdu(6)
                    verticalAlignment: VerticalAlignment.Bottom
                    input.keyLayout: KeyLayout.Alphanumeric
                    inputMode: TextFieldInputMode.Password
                    textStyle.textAlign: TextAlign.Center
                }
            }
    
            Container {
                layout: DockLayout {
    
                }
                topPadding: ui.sdu(2)
    
                Label {
                    verticalAlignment: VerticalAlignment.Top
                    text: qsTr("DOMAIN") + Retranslate.onLanguageChanged
                    textStyle.color: colors.colorE
                    textStyle.fontSize: FontSize.Small
                    textStyle.base: titilliumWeb.style
                }
    
                CustomTextField {
                    id: domain
                    topPadding: ui.sdu(6)
                    verticalAlignment: VerticalAlignment.Bottom
                    input.keyLayout: KeyLayout.EmailAddress
                    inputMode: TextFieldInputMode.EmailAddress
                    textStyle.textAlign: TextAlign.Center
                }
            }
    
            Container {
                layout: DockLayout {
    
                }
                topPadding: ui.sdu(2)
    
                Label {
                    verticalAlignment: VerticalAlignment.Top
                    text: qsTr("DISPLAY NAME (optional)") + Retranslate.onLanguageChanged
                    textStyle.color: colors.colorE
                    textStyle.fontSize: FontSize.Small
                    textStyle.base: titilliumWeb.style
                }
    
                CustomTextField {
                    id: displayName
                    topPadding: ui.sdu(6)
                    verticalAlignment: VerticalAlignment.Bottom
                    input.keyLayout: KeyLayout.Contact
                    inputMode: TextFieldInputMode.Text
                    textStyle.textAlign: TextAlign.Center
                    input.submitKey: SubmitKey.Done
                    input.submitKeyFocusBehavior: SubmitKeyFocusBehavior.Lose
                }
            }
    
            AssistantButton {
                topPadding: ui.sdu(4)
                text: qsTr("CONFIGURE ACCOUNT") + Retranslate.onLanguageChanged
                horizontalAlignment: HorizontalAlignment.Center
    
                onClicked: {
                    if (username.text.length == 0 || domain.text.length == 0) {
                        showDialog(qsTr("Please fill in at least your username and the domain") + Retranslate.onLanguageChanged)
                    } else {
                        var success = assistantModel.configureSipAccount(username.text, password.text, domain.text, displayName.text)
                        if (success) {
                            navigationPane.pop();
                        }
                    }
                }
            }
        }
    }
}
