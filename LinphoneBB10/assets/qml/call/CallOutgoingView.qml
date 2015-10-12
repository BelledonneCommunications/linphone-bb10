/*
 * CallOutgoingView.qml
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
            statsEnabled: false
        }

        Container {
            horizontalAlignment: HorizontalAlignment.Fill
            background: colors.colorF
            topPadding: ui.sdu(2)
            bottomPadding: ui.sdu(2)

            Label {
                text: qsTr("OUTGOING CALL") + Retranslate.onLanguageChanged
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.color: colors.colorA
                textStyle.fontWeight: FontWeight.Bold
                textStyle.base: titilliumWeb.style
                textStyle.fontSize: FontSize.XLarge
            }
        }

        Container {
            layout: DockLayout {
            
            }
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            horizontalAlignment: HorizontalAlignment.Fill

            Container {
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                
                InCallContactAvatar {
                    imageSource: inCallModel.outgoingCall.photo
                    horizontalAlignment: HorizontalAlignment.Center
                    maxHeight: ui.sdu(41)
                    maxWidth: ui.sdu(41)
                }
    
                Container {
                    layout: DockLayout {
                    
                    }
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                    topPadding: ui.sdu(2)
                    
                    Label {
                        text: inCallModel.outgoingCall.displayName
                        horizontalAlignment: HorizontalAlignment.Center
                        textStyle.fontSize: FontSize.XLarge
                        textStyle.color: colors.colorC
                        textStyle.base: titilliumWeb.style
                    }
                    
                    Container {
                        horizontalAlignment: HorizontalAlignment.Center
                        topPadding: ui.sdu(8)
                        
                        Label {
                            text: inCallModel.outgoingCall.sipUri
                            horizontalAlignment: HorizontalAlignment.Center
                            textStyle.color: colors.colorA
                            textStyle.base: titilliumWeb.style
                        }
                    }
                }
            }
        }

        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            layoutProperties: StackLayoutProperties {
                spaceQuota: 0.13
            }
            minHeight: ui.sdu(15)
            background: colors.colorF
            
            CustomImageToggle {
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
                imageSource: "asset:///images/call/micro_default.png"
                selectedImageSource: "asset:///images/call/micro_selected.png"
                selected: inCallModel.isSpeakerEnabled
                
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
                imageSource: "asset:///images/call/speaker_default.png"
                selectedImageSource: "asset:///images/call/speaker_selected.png"
                selected: inCallModel.isMicMuted
                
                gestureHandlers: TapHandler {
                    onTapped: {
                        inCallModel.isMicMuted = ! inCallModel.isMicMuted
                    }
                }
            }

            Container {
                layout: DockLayout {
                
                }
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 2
                }
                verticalAlignment: VerticalAlignment.Fill
                background: colors.colorD
                
                onTouch: {
                    if (event.isDown() || event.isMove()) {
                        background = colors.colorI
                    } else if (event.isUp() || event.isCancel()) {
                        background = colors.colorD
                        if (event.isUp()) {
                            inCallModel.hangUp(inCallModel.incomingCall);
                        }
                    }
                }
                
                onTouchExit: {
                    background = colors.colorD
                }

                ImageView {
                    imageSource: "asset:///images/call/call_hangup.png"
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                }
            }

        }
    }
}
