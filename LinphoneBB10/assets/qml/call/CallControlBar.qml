/*
 * CallControlBar.qml
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
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }
    minHeight: ui.sdu(15)
    background: colors.colorF
    visible: inCallModel.areControlsVisible
    
    CustomImageToggle {
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
        selected: inCallModel.isVideoEnabled
        imageSource: "asset:///images/call/camera_default.png"
        selectedImageSource: "asset:///images/call/camera_selected.png"
        enabled: settingsModel.videoEnabled
        
        gestureHandlers: TapHandler {
            onTapped: {
                if (settingsModel.videoEnabled) {
                    inCallModel.isVideoEnabled = ! inCallModel.isVideoEnabled
                }
            }
        }
    }
    
    CustomImageToggle {
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
        selected: inCallModel.isMicMuted
        imageSource: "asset:///images/call/micro_default.png"
        selectedImageSource: "asset:///images/call/micro_selected.png"
        
        gestureHandlers: TapHandler {
            onTapped: {
                inCallModel.isMicMuted = ! inCallModel.isMicMuted
            }
        }
    }
    
    CustomImageToggle {
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
        selected: inCallModel.isSpeakerEnabled
        imageSource: "asset:///images/call/speaker_default.png"
        selectedImageSource: "asset:///images/call/speaker_selected.png"
        
        gestureHandlers: TapHandler {
            onTapped: {
                inCallModel.isSpeakerEnabled = ! inCallModel.isSpeakerEnabled
            }
        }
    }
    
    CustomImageToggle {
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
        imageSource: "asset:///images/call/options_default.png"
        selectedImageSource: "asset:///images/call/options_selected.png"
        selected: optionsMenu.menuVisible
        
        gestureHandlers: TapHandler {
            onTapped: {
                optionsMenu.menuVisible = !optionsMenu.menuVisible
            }
        }
    }
}