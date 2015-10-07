/*
 * CallIncomingView.qml
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
                text: qsTr("INCOMING CALL") + Retranslate.onLanguageChanged
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
                    id: avatar
                    imageSource: inCallModel.currentCall.photo
                    horizontalAlignment: HorizontalAlignment.Center
                    maxHeight: ui.sdu(41)
                    maxWidth: ui.sdu(41)
                }
                
                Label {
                    text: inCallModel.currentCall.displayName
                    horizontalAlignment: HorizontalAlignment.Center
                    textStyle.fontSize: FontSize.XLarge
                    textStyle.color: colors.colorC
                    textStyle.base: titilliumWeb.style
                }
                
                Label {
                    text: inCallModel.currentCall.sipUri
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
            layoutProperties: StackLayoutProperties {
                spaceQuota: 0.13
            }
            minHeight: ui.sdu(15)
            
            Container {
                layout: DockLayout {
                
                }
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
                verticalAlignment: VerticalAlignment.Fill
                background: colors.colorD
                
                onTouch: {
                    if (event.isDown() || event.isMove()) {
                        background = colors.colorI
                    } else if (event.isUp() || event.isCancel()) {
                        background = colors.colorD
                    }
                }
                
                onTouchExit: {
                    background = colors.colorD
                }
                
                gestureHandlers: TapHandler {
                    onTapped: {
                        inCallModel.hangUp()
                    }
                }
                
                ImageView {
                    imageSource: "asset:///images/call/call_hangup.png"
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                }
            }
            
            Container {
                layout: DockLayout {
                
                }
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
                verticalAlignment: VerticalAlignment.Fill
                background: colors.colorA
                
                onTouch: {
                    if (event.isDown() || event.isMove()) {
                        background = colors.colorL
                    } else if (event.isUp() || event.isCancel()) {
                        background = colors.colorA
                    }
                }
                
                onTouchExit: {
                    background = colors.colorA
                }
                
                gestureHandlers: TapHandler {
                    onTapped: {
                        inCallModel.accept()
                    }
                }
                
                ImageView {
                    imageSource: "asset:///images/call/call_audio_start.png"
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                }
            }
        }
    }
}
