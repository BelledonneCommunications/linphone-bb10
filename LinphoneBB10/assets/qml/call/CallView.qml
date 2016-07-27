/*
 * CallView.qml
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

import ".."
import "../custom_controls"

Page {
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        background: Color.Black
        
        StatusBar {
            isInCall: true
            statsEnabled: true
            visible: true
            isHidden: !inCallModel.areControlsVisible
        }

        Container {
            layout: DockLayout {

            }
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
            
            CallStats {
                id: statsMenu
            }

            Container {
                layout: DockLayout {

                }
                id: callPageContent
                background: colors.colorH
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill

                CallVideoView {
                    visible: ! inCallModel.isInConference && inCallModel.runningCallsNotInAnyConferenceCount > 0 && inCallModel.isVideoEnabled
                }

                InCallContactAvatar {
                    visible: currentCallHeader.visible && ! inCallModel.isVideoEnabled && inCallModel.areControlsVisible
                    imageSource: inCallModel.currentCall.photo
                    verticalAlignment: VerticalAlignment.Top
                    topPadding: ui.sdu(21)
                }

                CurrentCallHeaderView {
                    id: currentCallHeader
                    title: inCallModel.currentCall.displayName
                    subtitle: inCallModel.currentCall.callTime
                    visible: ! inCallModel.isInConference && inCallModel.runningCallsNotInAnyConferenceCount > 0 && inCallModel.areControlsVisible
                }

                SwitchCameraButton {
                    visible: currentCallHeader.visible && inCallModel.isVideoEnabled
                }

                PausedByRemoteView {
                    visible: inCallModel.isPausedByRemote
                    bottomPadding: ui.sdu(30)
                }

                PauseCurrentCallButton {
                    visible: currentCallHeader.visible
                }

                AllCallsPausedView {
                    visible: ! inCallModel.isInConference && inCallModel.runningCallsNotInAnyConferenceCount == 0
                    bottomPadding: ui.sdu(30)
                }

                ConferenceView {
                    visible: inCallModel.isInConference
                    bottomPadding: ui.sdu(30)
                }

                PausedCallsView {
                    bottomPadding: inCallModel.areControlsVisible ? ui.sdu(30) : 0
                }

                Container {
                    layout: DockLayout {

                    }
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1
                    }
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Fill
                    id: numpad
                    visible: false
                    leftPadding: ui.sdu(2)
                    rightPadding: ui.sdu(2)
                    topPadding: ui.sdu(2)
                    bottomPadding: ui.sdu(30)

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

                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.TopToBottom
                    }
                    horizontalAlignment: HorizontalAlignment.Fill
                    verticalAlignment: VerticalAlignment.Bottom
                    visible: inCallModel.areControlsVisible
                    
                    CallOptionsMenuBar {
                        id: optionsMenu
                        menuVisible: false
                        visible: menuVisible
                    }

                    CallControlBar {

                    }

                    CallMenuBar {

                    }
                }
                
                Container {
                    id: callFadeContainer
                    verticalAlignment: VerticalAlignment.Fill
                    horizontalAlignment: HorizontalAlignment.Fill
                    background: colors.colorC
                    opacity: callPageContent.translationX > 0 ? 0.9 : 0
                    
                    onTouch: {
                        if (callPageContent.translationX > 0) {
                            callPageContent.translationX = 0;
                        }
                    }
                }
            }

            ZrtpDialog {
                visible: inCallModel.callStatsModel.zrtpDialogVisible
            }

            AcceptCallUpdatedByRemoteDialog {
                visible: inCallModel.callUpdatedByRemoteInProgress
            }
        }
    }

    function callEnded(call) {
        if (! inCallModel.isInCall) {
            callPageContent.translationX = 0;
        }
    }

    onCreationCompleted: {
        linphoneManager.callEnded.connect(callEnded);
    }
}
