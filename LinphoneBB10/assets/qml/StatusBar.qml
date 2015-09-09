/*
 * StatusBar.qml
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
import bb.system 1.0

Container {
    property alias messagesCountText: messagesCount.text
    property alias securityImageSource: security.defaultImageSource
    property bool menuEnabled: true
    property bool statsEnabled: false
    property bool isInCall: false

    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }

        leftPadding: ui.sdu(2)
        rightPadding: ui.sdu(2)
        topPadding: ui.sdu(2)
        bottomPadding: ui.sdu(2)
        background: colors.colorA
        clipContentToBounds: false
        minHeight: ui.sdu(10)

        Container {
            rightPadding: ui.sdu(2)
            verticalAlignment: VerticalAlignment.Center

            ImageButton {
                visible: ! isInCall
                enabled: menuEnabled
                opacity: menuEnabled ? 1 : 0.2
                defaultImageSource: "asset:///images/statusbar/menu.png"
                verticalAlignment: VerticalAlignment.Center

                onClicked: {
                    if (pageContent.translationX == 0) {
                        pageContent.translationX = sideMenu.minWidth;
                    } else {
                        pageContent.translationX = 0;
                    }
                }
            }

            ImageButton {
                visible: isInCall
                enabled: statsEnabled
                opacity: statsEnabled ? 1 : 0.2
                defaultImageSource: inCallModel.callStatsModel.callQualityIcon
                verticalAlignment: VerticalAlignment.Center

                onClicked: {
                    if (callPageContent.translationX == 0) {
                        callPageContent.translationX = statsMenu.minWidth;
                    } else {
                        callPageContent.translationX = 0;
                    }
                }
            }
        }

        ImageView {
            imageSource: linphoneManager.registrationStatusImage
            verticalAlignment: VerticalAlignment.Center
            scalingMethod: ScalingMethod.AspectFit

            gestureHandlers: TapHandler {
                onTapped: {
                    linphoneManager.refreshRegisters();
                }
            }
        }

        Label {
            verticalAlignment: VerticalAlignment.Center
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            text: linphoneManager.registrationStatusText
            textStyle.color: colors.colorH
            textStyle.base: titilliumWeb.style

            gestureHandlers: TapHandler {
                onTapped: {
                    linphoneManager.refreshRegisters();
                }
            }
        }

        ImageView {
            id: voicemail
            visible: ! isInCall && messagesCountText > 0
            verticalAlignment: VerticalAlignment.Center
            imageSource: "asset:///images/statusbar/voicemail.png"
            scalingMethod: ScalingMethod.AspectFit
        }

        Label {
            id: messagesCount
            visible: ! isInCall
            verticalAlignment: VerticalAlignment.Center
            text: messagesCountText
            textStyle.color: colors.colorH
            textStyle.base: titilliumWeb.style
        }

        ImageButton {
            id: security
            visible: isInCall
            verticalAlignment: VerticalAlignment.Center
            defaultImageSource: inCallModel.callStatsModel.callSecurityIcon

            onClicked: {
                if (inCallModel.callStatsModel.callSecurityToken.length > 0) {
                    zrtpDialog.visible = true;
                }
            }
        }
    }
}
