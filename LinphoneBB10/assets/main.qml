/*
 * main.qml
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

import "qml"
import "qml/custom_controls"
import "qml/menu"
import "qml/contacts"
import "qml/chat"
import "qml/call"
import "qml/history"
import "qml/settings"

NavigationPane {
    id: navigationPane
    backButtonsVisible: false
    peekEnabled: false

    onPopTransitionEnded: {
        page.destroy();
    }

    Page {
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }

            StatusBar {
                visible: !bps.isKeyboardVisible
            }

            Container {
                layout: DockLayout {

                }
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill

                Menu {
                    id: menu
                }

                Container {
                    layout: DockLayout {

                    }
                    id: pageContent
                    verticalAlignment: VerticalAlignment.Fill
                    horizontalAlignment: HorizontalAlignment.Fill

                    Container {
                        layout: StackLayout {
                            orientation: LayoutOrientation.TopToBottom
                        }
                        verticalAlignment: VerticalAlignment.Fill
                        horizontalAlignment: HorizontalAlignment.Fill
                        background: colors.colorH

                        Container {
                            layout: DockLayout {

                            }
                            layoutProperties: StackLayoutProperties {
                                spaceQuota: 1
                            }

                            ControlDelegate {
                                id: tabDelegate
                                source: "qml/DialerView.qml"
                                
                                onSourceChanged: {
                                    if (source.toString() != "asset:///qml/chat/ChatView.qml") {
                                        chatListModel.chatModel.setSelectedConversationSipAddress("");
                                    }
                                }
                            }
                        }

                        CustomTabbedPane {
                            id: tabs
                            visible: !bps.isKeyboardVisible
                        }
                    }
                    
                    Container {
                        id: fadeContainer
                        verticalAlignment: VerticalAlignment.Fill
                        horizontalAlignment: HorizontalAlignment.Fill
                        background: colors.colorC
                        opacity: 0
                        
                        onTouch: {
                            if (pageContent.translationX > 0) {
                                pageContent.translationX = 0;
                                fadeContainer.opacity = 0;
                            }
                        }
                    }
                }

                Container {
                    layout: DockLayout {

                    }
                    id: actionConfirmationScreen
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
                            id: actionConfirmationMessage
                            textStyle.color: colors.colorH
                            textStyle.base: titilliumWeb.style
                            multiline: true
                            textStyle.textAlign: TextAlign.Center
                        }

                        Container {
                            layout: StackLayout {
                                orientation: LayoutOrientation.LeftToRight
                            }
                            horizontalAlignment: HorizontalAlignment.Center
                            topPadding: ui.sdu(7)

                            CancelButton {
                                id: cancelAction
                                onCancelClicked: {
                                    actionConfirmationScreen.visible = false
                                }
                            }

                            DeleteButton {
                                id: confirmAction
                                leftMargin: ui.sdu(3)
                            }
                        }
                    }
                }
            }
        }
    }

    attachedObjects: [
        Sheet {
            id: incomingCallView
            peekEnabled: false
            content: IncomingCallView {

            }
        },
        Sheet {
            id: inCallView
            peekEnabled: false
            content: InCallView {

            }
        },
        Sheet {
            id: outgoingCallView
            peekEnabled: false
            content: OutgoingCallView {

            }
        },
        ComponentDefinition {
            id: assistant
            source: "qml/assistant/AssistantView.qml"
        },
        ComponentDefinition {
            id: settings
            source: "qml/settings/SettingsView.qml"
        },
        ComponentDefinition {
            id: about
            source: "qml/menu/AboutView.qml"
        },
        TextStyleDefinition {
            id: titilliumWeb
            base: SystemDefaults.TextStyles.BodyText

            rules: [
                FontFaceRule {
                    source: "asset:///fonts/TitilliumWeb-Regular.ttf"
                    fontFamily: "titilliumWeb"
                }
            ]
            fontFamily: "titilliumWeb, sans-serif"
        }
    ]

    function incomingCallReceived(call) {
        incomingCallView.open();
    }

    function callConnected(call) {
        incomingCallView.close();
        outgoingCallView.close();
        inCallView.open();
    }

    function callEnded(call) {
        inCallView.close();
        outgoingCallView.close();
        incomingCallView.close();
    }

    function outgoingCallInit(call) {
        outgoingCallView.open();
    }

    onCreationCompleted: {
        linphoneManager.incomingCallReceived.connect(incomingCallReceived);
        linphoneManager.callConnected.connect(callConnected);
        linphoneManager.callEnded.connect(callEnded);
        linphoneManager.outgoingCallInit.connect(outgoingCallInit);
    }
}
