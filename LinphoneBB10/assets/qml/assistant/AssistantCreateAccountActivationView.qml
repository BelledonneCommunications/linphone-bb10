/*
* AssistantCreateAccountActivationView.qml
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
    
    function isAccountActivated(yesno) {
        if (yesno) {
            assistantModel.configureAccount();
            navigationPane.pop();
        } else {
            showDialog(qsTr("Your account isn't activated yet\r\nClick on the link in the email we sent you") + Retranslate.onLanguageChanged)
        }
    }
    
    onCreationCompleted: {
        assistantModel.accountActivated.connect(isAccountActivated);
    }
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }
        horizontalAlignment: HorizontalAlignment.Fill
        
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
                text: qsTr("2/2") + Retranslate.onLanguageChanged
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
            
            Label {
                text: qsTr("Activate your account") + Retranslate.onLanguageChanged
                textStyle.color: colors.colorD
                textStyle.fontWeight: FontWeight.Bold
                textStyle.base: titilliumWeb.style
                horizontalAlignment: HorizontalAlignment.Center
            }
            
            Label {
                text: qsTr("An email has been sent to the email address you gave us.\r\nYou have to click in the link inside it to activate your account.\r\nOnce it is done, click on the button below to complete your account setup.") + Retranslate.onLanguageChanged
                textStyle.color: colors.colorD
                textStyle.base: titilliumWeb.style
                horizontalAlignment: HorizontalAlignment.Center
                multiline: true
                textStyle.textAlign: TextAlign.Center
            }
            
            AssistantButton {
                topPadding: ui.sdu(4)
                text: qsTr("FINALIZE CONFIGURATION") + Retranslate.onLanguageChanged
                horizontalAlignment: HorizontalAlignment.Center
                
                onClicked: {
                    assistantModel.isAccountActivated();
                }
            }
        }
    }
}
