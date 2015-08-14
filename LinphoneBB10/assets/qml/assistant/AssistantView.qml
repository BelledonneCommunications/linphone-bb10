/*
 * AssistantView.qml
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
            menuEnabled: false
        }

        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            minHeight: ui.sdu(15)
            background: colors.colorF

            TopBarButton {
                imageSource: "asset:///images/back.png"
                visibility: assistantDelegate.source.toString() != "asset:///qml/assistant/AssistantHomeView.qml"

                gestureHandlers: TapHandler {
                    onTapped: {
                        assistantDelegate.source = assistantModel.getPreviousPage()
                    }
                }
            }

            Container {
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 3
                }
                verticalAlignment: VerticalAlignment.Center

                Label {
                    text: qsTr("ASSISTANT") + Retranslate.onLanguageChanged
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    textStyle.color: colors.colorA
                    textStyle.fontWeight: FontWeight.Bold
                    textStyle.fontSize: FontSize.XLarge
                    textStyle.base: titilliumWeb.style
                }
            }

            TopBarButton {
                imageSource: "asset:///images/assistant/dialer_back.png"

                gestureHandlers: TapHandler {
                    onTapped: {
                        navigationPane.pop();
                    }
                }
            }
        }
        
        Container {
            layout: DockLayout {
                
            }
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            
            ControlDelegate {
                id: assistantDelegate
                source: "AssistantHomeView.qml"
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
            }
            
            Container {
                layout: DockLayout {
                
                }
                id: dialogContainer
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill
                background: colors.colorC
                opacity: 0.9
                visible: false
                
                Container {
                    layout: StackLayout {
                        orientation: LayoutOrientation.TopToBottom
                    }
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Center
                    leftPadding: ui.sdu(5)
                    rightPadding: ui.sdu(5)
                    
                    Label {
                        id: dialogMessage
                        textStyle.color: colors.colorH
                        textStyle.base: titilliumWeb.style
                        multiline: true
                        textStyle.textAlign: TextAlign.Center
                        horizontalAlignment: HorizontalAlignment.Center
                    }
                    
                    CustomButton {
                        topPadding: ui.sdu(5)
                        text: qsTr("Continue") + Retranslate.onLanguageChanged
                        imageSource: "asset:///images/resizable_cancel_button.amd"
                        textStyle.color: colors.colorC
                        textStyle.base: titilliumWeb.style
                        horizontalAlignment: HorizontalAlignment.Center
                        
                        onButtonClicked: {
                            dialogContainer.visible = false
                        }
                    }
                }
            }
        }
    }
    
    function showDialog(text) {
        dialogMessage.text = text
        dialogContainer.visible = true
    }
}
