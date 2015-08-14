/*
 * AssistantCreateAccountView.qml
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
    
    function isUsernameAvailable(yesno) {
        if (yesno) {
            if (password.text == confirmPassword.text) {
                if (password.text.length >= 6) {
                    if (assistantModel.isValidEmail(email.text)) {
                        assistantModel.createLinphoneAccount(username.text, password.text, email.text)
                    } else {
                        showDialog(qsTr("Please fill in a valid email to receive the activation link") + Retranslate.onLanguageChanged)
                    }
                } else {
                    showDialog(qsTr("Password is too short\r\n(6 characters minimum)") + Retranslate.onLanguageChanged)
                }
            } else {
                showDialog(qsTr("Passwords are different") + Retranslate.onLanguageChanged)
            }
        } else {
            showDialog(qsTr("Username already in use,\r\nplease choose another one") + Retranslate.onLanguageChanged)
        }
    }
    
    function isAccountCreated(yesno) {
        if (yesno) {
            assistantDelegate.source = "AssistantConfirmAccountActivationView.qml";
        } else {
            showDialog(qsTr("Account creation failed\r\n,please try again later") + Retranslate.onLanguageChanged)
        }
    }
    
    onCreationCompleted: {
        assistantModel.usernameAvailable.connect(isUsernameAvailable);
        assistantModel.accountCreated.connect(isAccountCreated);
    }

    layoutProperties: AbsoluteLayoutProperties {

    }
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }
    
        Container {
            layout: DockLayout {
    
            }
            horizontalAlignment: HorizontalAlignment.Center
            minHeight: ui.sdu(12)
    
            Label {
                text: qsTr("CREATE AN ACCOUNT") + Retranslate.onLanguageChanged
                textStyle.color: colors.colorC
                textStyle.base: titilliumWeb.style
                textStyle.fontSize: FontSize.Large
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Top
            }
    
            Label {
                text: qsTr("1/2") + Retranslate.onLanguageChanged
                textStyle.color: colors.colorD
                textStyle.base: titilliumWeb.style
                textStyle.fontSize: FontSize.Small
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Bottom
            }
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
                    textStyle.color: colors.colorD
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
                    textStyle.color: colors.colorD
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
                    text: qsTr("CONFIRM THE PASSWORD") + Retranslate.onLanguageChanged
                    textStyle.color: colors.colorD
                    textStyle.fontSize: FontSize.Small
                    textStyle.base: titilliumWeb.style
                }
    
                CustomTextField {
                    id: confirmPassword
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
                    text: qsTr("EMAIL (we'll send you an activation link)") + Retranslate.onLanguageChanged
                    textStyle.color: colors.colorD
                    textStyle.fontSize: FontSize.Small
                    textStyle.base: titilliumWeb.style
                }
    
                CustomTextField {
                    id: email
                    topPadding: ui.sdu(6)
                    verticalAlignment: VerticalAlignment.Bottom
                    input.keyLayout: KeyLayout.EmailAddress
                    inputMode: TextFieldInputMode.EmailAddress
                    textStyle.textAlign: TextAlign.Center
                    input.submitKey: SubmitKey.Done
                    input.submitKeyFocusBehavior: SubmitKeyFocusBehavior.Lose
                }
            }
    
            AssistantButton {
                id: createAccountButton
                topPadding: ui.sdu(4)
                text: qsTr("CREATE ACCOUNT") + Retranslate.onLanguageChanged
                horizontalAlignment: HorizontalAlignment.Center
    
                onClicked: {
                    if (username.text.length >= 4) {
                        assistantModel.isUsernameAvailable(username.text)
                    } else {
                        showDialog(qsTr("Username is too short\r\n(4 characters minimum)") + Retranslate.onLanguageChanged)
                    }
                }
            }
        }
    }
}
