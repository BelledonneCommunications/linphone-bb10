/*
 * CallAudioView.qml
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
        orientation: LayoutOrientation.TopToBottom
    }
    layoutProperties: StackLayoutProperties {
        spaceQuota: 1
    }
    horizontalAlignment: HorizontalAlignment.Fill

    Container {
        layout: DockLayout {

        }
        verticalAlignment: VerticalAlignment.Top
        horizontalAlignment: HorizontalAlignment.Fill
        minHeight: ui.sdu(20)
        maxHeight: ui.sdu(20)
        visible: inCallModel.areControlsVisible

        Container {
            background: colors.colorH
            opacity: 0.7
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
        }

        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center

            Label {
                text: inCallModel.currentCall.displayName
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.fontSize: FontSize.XLarge
                textStyle.color: colors.colorC
                textStyle.base: titilliumWeb.style
            }

            Label {
                text: inCallModel.currentCall.callTime
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.color: colors.colorA
                textStyle.base: titilliumWeb.style
            }
        }
    }

    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        leftPadding: ui.sdu(5)
        rightPadding: ui.sdu(5)
        topPadding: ui.sdu(2)
        visible: inCallModel.areControlsVisible

        ImageButton {
            defaultImageSource: "asset:///images/call/camera_switch_default.png"
            pressedImageSource: "asset:///images/call/camera_switch_over.png"
            disabledImageSource: "asset:///images/call/camera_switch_disabled.png"
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            visible: inCallModel.isVideoEnabled

            onClicked: {
                inCallModel.switchCamera();
            }
        }

        Container {
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
        }

        ImageButton {
            defaultImageSource: "asset:///images/call/pause_big_default.png"
            pressedImageSource: "asset:///images/call/pause_big_over_selected.png"
            disabledImageSource: "asset:///images/call/pause_big_disabled.png"
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            enabled: !inCallModel.mediaInProgress
            
            onClicked: {
                inCallModel.pauseCurrentCall();
            }
        }
    }
    
    InCallContactAvatar {
        visible: !inCallModel.isVideoEnabled
        imageSource: inCallModel.currentCall.photo
        horizontalAlignment: HorizontalAlignment.Center
        maxWidth: ui.sdu(41)
        maxHeight: ui.sdu(41)
    }
}