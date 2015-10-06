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
import "qml/sidemenu"
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
    
    onPushTransitionEnded: {
        pageContent.translationX = 0;
    }

    Page {
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }

            StatusBar {
                id: statusbar
                visible: !bps.isKeyboardVisible
            }

            Container {
                layout: DockLayout {

                }
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill

                SideMenu {
                    id: sideMenu
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
                                    if (source.toString() != "asset:///qml/chat/ChatConversationView.qml") {
                                        chatListModel.chatModel.setSelectedConversationSipAddress("");
                                    } else {
                                        tabs.setChatTabSelected();
                                    }
                                }
                            }
                        }

                        TabBar {
                            id: tabs
                            visible: !bps.isKeyboardVisible
                        }
                    }
                    
                    Container {
                        id: fadeContainer
                        verticalAlignment: VerticalAlignment.Fill
                        horizontalAlignment: HorizontalAlignment.Fill
                        background: colors.colorC
                        opacity: pageContent.translationX > 0 ? 0.9 : 0
                        
                        onTouch: {
                            if (pageContent.translationX > 0) {
                                pageContent.translationX = 0;
                            }
                        }
                    }
                }

                ConfirmationDialog {
                    id: actionConfirmationScreen
                }
            }
        }
    }

    attachedObjects: [
        Sheet {
            id: incomingCallView
            peekEnabled: false
            content: CallIncomingView {

            }
        },
        Sheet {
            id: inCallView
            peekEnabled: false
            content: CallView {

            }
        },
        Sheet {
            id: outgoingCallView
            peekEnabled: false
            content: CallOutgoingView {

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
            source: "qml/sidemenu/AboutView.qml"
        },
        ComponentDefinition {
            id: accountSettings
            source: "qml/settings/SettingsAccountView.qml"
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
    
    function newOutgoingCallOrCallTransfer(number) {
        if (inCallModel.dialerCallButtonMode == 1) { // 0 is default, 1 is transfer, 2 is add call
            linphoneManager.transferCall(number);
            inCallModel.dialerCallButtonMode = 0;
            inCallView.open();
        } else {
            linphoneManager.call(number);
        }
    }

    onCreationCompleted: {
        linphoneManager.incomingCallReceived.connect(incomingCallReceived);
        linphoneManager.callConnected.connect(callConnected);
        linphoneManager.callEnded.connect(callEnded);
        linphoneManager.outgoingCallInit.connect(outgoingCallInit);
        
        if (linphoneManager.shouldStartWizardWhenAppStarts()) {
            var assistantPage = assistant.createObject();
            navigationPane.push(assistantPage);
            linphoneManager.firstLaunchSuccessful();
        }
    }
}
