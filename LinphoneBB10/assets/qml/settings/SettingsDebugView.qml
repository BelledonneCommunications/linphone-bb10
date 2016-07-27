/*
 * SettingsDebugView.qml
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
    
    SettingsToggle {
        text: qsTr("Debug") + Retranslate.onLanguageChanged
        checked: settingsModel.debugEnabled
        horizontalAlignment: HorizontalAlignment.Fill
        
        onToggled: {
            settingsModel.debugEnabled = checked;
        }
    }
    
    SettingsToggle {
        text: qsTr("Log collection") + Retranslate.onLanguageChanged
        checked: settingsModel.logCollectionEnabled
        horizontalAlignment: HorizontalAlignment.Fill
        
        onToggled: {
            settingsModel.logCollectionEnabled = checked;
        }
    }
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        
        CustomButton {
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            text: qsTr("Reset logs") + Retranslate.onLanguageChanged
            imageSource: "asset:///images/resizable_confirm_delete_button.amd"
            pressedImageSource: "asset:///images/resizable_confirm_delete_button_over.amd"
            textStyle.color: colors.colorH
            textStyle.base: titilliumWeb.style
            leftPadding: ui.sdu(2)
            rightPadding: ui.sdu(2)
            visible: settingsModel.logCollectionEnabled
            
            onButtonClicked: {
                settingsModel.resetLogs();
            }
        }
        
        CustomButton {
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            text: qsTr("Upload logs") + Retranslate.onLanguageChanged
            imageSource: "asset:///images/resizable_cancel_button.amd"
            pressedImageSource: "asset:///images/resizable_cancel_button_over.amd"
            textStyle.color: colors.colorC
            textStyle.base: titilliumWeb.style
            leftPadding: ui.sdu(2)
            rightPadding: ui.sdu(2)
            visible: settingsModel.logCollectionEnabled
            
            onButtonClicked: {
                settingsModel.uploadLogs();
            }
        }
    }
}