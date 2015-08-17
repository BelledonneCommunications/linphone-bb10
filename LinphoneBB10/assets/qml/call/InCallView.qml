/*
 * InCallView.qml
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

import ".."
import "../custom_controls"

Page {
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }

        StatusBar {
            isInCall: true
        }

        Container {
            layout: DockLayout {

            }
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill

            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.TopToBottom
                }
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill

                Container {
                    visible: inCallModel.isVideoEnabled && ! inCallModel.isPaused
                    layout: DockLayout {

                    }
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1
                    }
                    horizontalAlignment: HorizontalAlignment.Fill

                    ForeignWindowControl {
                        windowId: "LinphoneVideoWindowId" // Do not change the name of this windowId
                        visible: boundToWindow // becomes visible once bound to a window
                        updatedProperties: WindowProperty.Position | WindowProperty.Size
                        horizontalAlignment: HorizontalAlignment.Fill
                        verticalAlignment: VerticalAlignment.Fill
                        
                        onCreationCompleted: {
                            inCallModel.onVideoSurfaceCreationCompleted(windowId, windowGroup);
                        }

                        gestureHandlers: TapHandler {
                            onTapped: {
                                inCallModel.switchFullScreenMode();
                            }
                        }
                    }
                    
                    ForeignWindowControl {
                        windowId: "LinphoneLocalVideoWindowId" // Do not change the name of this windowId
                        visible: boundToWindow // becomes visible once bound to a window
                        updatedProperties: WindowProperty.Position | WindowProperty.Size | WindowProperty.Visible
                        horizontalAlignment: HorizontalAlignment.Right
                        verticalAlignment: VerticalAlignment.Bottom
                        preferredWidth: inCallModel.deviceOrientation == 0 ? ui.sdu(20) : ui.sdu(26.7)
                        preferredHeight: inCallModel.deviceOrientation == 0 ? ui.sdu(26.7) : ui.sdu(20)
                    }

                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.TopToBottom
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
                                    text: inCallModel.displayName
                                    horizontalAlignment: HorizontalAlignment.Center
                                    textStyle.fontSize: FontSize.XLarge
                                    textStyle.color: colors.colorC
                                    textStyle.base: titilliumWeb.style
                                }

                                Label {
                                    text: inCallModel.callTime
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

                                onClicked: {
                                    inCallModel.switchCamera();
                                }
                            }

                            Container {
                                layoutProperties: StackLayoutProperties {
                                    spaceQuota: 1
                                }
                            }

                            CustomImageToggle {
                                imageSource: "asset:///images/call/pause_big_default.png"
                                selectedImageSource: "asset:///images/call/pause_big_over_selected.png"
                                verticalAlignment: VerticalAlignment.Center
                                horizontalAlignment: HorizontalAlignment.Center
                                selected: inCallModel.isPaused

                                gestureHandlers: TapHandler {
                                    onTapped: {
                                        inCallModel.togglePause();
                                    }
                                }
                            }
                        }
                    }
                }

                Container {
                    visible: ! inCallModel.isVideoEnabled || inCallModel.isPaused
                    layout: DockLayout {

                    }
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1
                    }
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Fill

                    Container {
                        verticalAlignment: VerticalAlignment.Center
                        horizontalAlignment: HorizontalAlignment.Fill

                        Container {
                            layout: DockLayout {

                            }
                            horizontalAlignment: HorizontalAlignment.Fill

                            InCallContactAvatar {
                                imageSource: inCallModel.photo
                                horizontalAlignment: HorizontalAlignment.Center
                                verticalAlignment: VerticalAlignment.Center
                                maxWidth: ui.sdu(41)
                                maxHeight: ui.sdu(41)
                            }

                            CustomImageToggle {
                                imageSource: "asset:///images/call/pause_big_default.png"
                                selectedImageSource: "asset:///images/call/pause_big_over_selected.png"
                                verticalAlignment: VerticalAlignment.Bottom
                                horizontalAlignment: HorizontalAlignment.Center
                                selected: inCallModel.isPaused
                                leftPadding: ui.sdu(50)
                                topPadding: ui.sdu(20)

                                gestureHandlers: TapHandler {
                                    onTapped: {
                                        inCallModel.togglePause();
                                    }
                                }
                            }
                        }

                        Label {
                            text: inCallModel.displayName
                            horizontalAlignment: HorizontalAlignment.Center
                            textStyle.fontSize: FontSize.XLarge
                            textStyle.color: colors.colorC
                            textStyle.base: titilliumWeb.style
                        }

                        Label {
                            text: inCallModel.callTime
                            horizontalAlignment: HorizontalAlignment.Center
                            textStyle.color: colors.colorA
                            textStyle.base: titilliumWeb.style
                        }
                    }
                }
            }

            Container {
                layout: DockLayout {

                }
                id: numpad
                visible: false
                leftPadding: ui.sdu(2)
                rightPadding: ui.sdu(2)
                topPadding: ui.sdu(2)
                bottomPadding: ui.sdu(2)

                Container {
                    verticalAlignment: VerticalAlignment.Fill
                    horizontalAlignment: HorizontalAlignment.Fill
                    background: colors.colorF
                    opacity: 0.95
                }

                Numpad {
                    leftPadding: ui.sdu(3)
                    rightPadding: ui.sdu(3)
                    topPadding: ui.sdu(3)
                    bottomPadding: ui.sdu(3)
                }
            }
        }

        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            minHeight: ui.sdu(15)
            background: colors.colorF
            visible: inCallModel.areControlsVisible

            CustomToggleButton {
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
                selected: inCallModel.isVideoEnabled
                imageSource: "asset:///images/call/camera_default.png"
                selectedImageSource: "asset:///images/call/camera_selected.png"

                gestureHandlers: TapHandler {
                    onTapped: {
                        inCallModel.isVideoEnabled = ! inCallModel.isVideoEnabled
                    }
                }
            }

            CustomToggleButton {
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

            CustomToggleButton {
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

            CustomToggleButton {
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
                imageSource: "asset:///images/call/options_default.png"
                selectedImageSource: "asset:///images/call/options_selected.png"
                enabled: false

                gestureHandlers: TapHandler {
                    onTapped: {

                    }
                }
            }
        }

        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            minHeight: ui.sdu(15)
            visible: inCallModel.areControlsVisible

            Container {
                layout: DockLayout {

                }
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Center
                background: colors.colorC

                gestureHandlers: TapHandler {
                    onTapped: {
                        numpad.visible = ! numpad.visible
                        numpadToggle.selected = numpad.visible
                    }
                }

                CustomTab {
                    id: numpadToggle
                    imageSource: selected ? "asset:///images/call/dialer_alt_back.png" : "asset:///images/footer_dialer.png"
                    verticalAlignment: VerticalAlignment.Fill
                    horizontalAlignment: HorizontalAlignment.Fill
                }
            }

            Container {
                layout: DockLayout {

                }
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 2
                }
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Center
                background: colors.colorD

                onTouch: {
                    if (event.isDown() || event.isMove()) {
                        background = colors.colorI
                    } else if (event.isUp() || event.isCancel()) {
                        background = colors.colorD
                        if (event.isUp()) {
                            inCallModel.hangUp()
                        }
                    }
                }

                onTouchExit: {
                    background = colors.colorD
                }

                ImageView {
                    imageSource: "asset:///images/call/call_hangup.png"
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                }
            }

            Container {
                layout: DockLayout {

                }
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Center
                background: colors.colorC
                
                gestureHandlers: TapHandler {
                    onTapped: {
                        chatListModel.viewConversation(inCallModel.sipUri);
                        tabDelegate.source = "../chat/ChatView.qml"
                        inCallView.close();
                    }
                }

                ImageView {
                    imageSource: "asset:///images/footer_chat.png"
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                    opacity: enabled ? 1 : 0.2
                }
            }
        }
    }
}
