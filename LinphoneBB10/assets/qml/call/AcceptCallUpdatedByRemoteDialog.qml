/*
 * AcceptCallUpdatedByRemoteDialog.qml
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

Container {
    layout: DockLayout {
    
    }
    verticalAlignment: VerticalAlignment.Fill
    horizontalAlignment: HorizontalAlignment.Fill
    background: colors.colorC
    opacity: 0.9
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Center
        leftPadding: ui.sdu(5)
        rightPadding: ui.sdu(5)
        
        Label {
            text: qsTr("Your correspondent would like to turn on the video") + Retranslate.onLanguageChanged
            textStyle.color: colors.colorH
            textStyle.base: titilliumWeb.style
            multiline: true
            textStyle.textAlign: TextAlign.Center
            horizontalAlignment: HorizontalAlignment.Center
        }
        
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            horizontalAlignment: HorizontalAlignment.Center
            
            CustomButton {
                topPadding: ui.sdu(5)
                text: qsTr("Deny") + Retranslate.onLanguageChanged
                imageSource: "asset:///images/resizable_cancel_button.amd"
                textStyle.color: colors.colorC
                textStyle.base: titilliumWeb.style
                horizontalAlignment: HorizontalAlignment.Center
                
                onButtonClicked: {
                    inCallModel.acceptCallUpdate(false);
                }
            }
            
            CustomButton {
                topPadding: ui.sdu(5)
                text: qsTr("Accept") + Retranslate.onLanguageChanged
                imageSource: "asset:///images/resizable_confirm_delete_button.amd"
                textStyle.color: colors.colorH
                textStyle.base: titilliumWeb.style
                horizontalAlignment: HorizontalAlignment.Center
                leftMargin: ui.sdu(3)
                
                onButtonClicked: {
                    inCallModel.acceptCallUpdate(true);
                }
            }
        }
    }
}