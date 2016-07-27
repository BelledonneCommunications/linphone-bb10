/*
 * CallOptionsMenuBar.qml
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
import bb.displayInfo 1.0

import "../custom_controls"

Container {
    property bool menuVisible
    
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }
    background: colors.colorF
    horizontalAlignment: HorizontalAlignment.Right
    
    attachedObjects: [
        DisplayInfo {
            id: displayInfo
        }
    ]
    
    CustomImageToggle {
        minHeight: ui.sdu(15)
        minWidth: displayInfo.pixelSize.width / 4
        imageSource: "asset:///images/call/options_start_conference.png"
        enabled: inCallModel.isConferenceAllowed
        gestureHandlers: TapHandler {
            onTapped: {
                if (enabled) {
                    optionsMenu.menuVisible = false;
                    inCallModel.startConference();
                }
            }
        }
    }
    
    CustomImageToggle {
        minHeight: ui.sdu(15)
        minWidth: displayInfo.pixelSize.width / 4
        imageSource: "asset:///images/call/options_add_call.png"
        enabled: inCallModel.isMultiCallAllowed
        gestureHandlers: TapHandler {
            onTapped: {
                if (enabled) {
                    optionsMenu.menuVisible = false;
                    inCallModel.dialerCallButtonMode = 2;
                    tabDelegate.source = "../DialerView.qml"
                    inCallView.close();
                }
            }
        }
    }
    
    CustomImageToggle {
        minHeight: ui.sdu(15)
        minWidth: displayInfo.pixelSize.width / 4
        imageSource: "asset:///images/call/options_transfer_call.png"
        enabled: inCallModel.isCallTransferAllowed
        gestureHandlers: TapHandler {
            onTapped: {
                if (enabled) {
                    optionsMenu.menuVisible = false;
                    inCallModel.dialerCallButtonMode = 1;
                    tabDelegate.source = "../DialerView.qml"
                    inCallView.close();
                }
            }
        }
    }
}