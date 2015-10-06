/*
 * DialerView.qml
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

import "custom_controls"

Container {
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }

    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        minHeight: ui.sdu(15)
        background: colors.colorF

        TextField {
            id: inputNumber
            hintText: qsTr("Enter a number or an address") + Retranslate.onLanguageChanged
            verticalAlignment: VerticalAlignment.Center
            textStyle.color: colors.colorC
            textStyle.base: titilliumWeb.style
            textStyle.fontSize: FontSize.Large
            inputMode: TextFieldInputMode.EmailAddress
            maximumLength: 40
            backgroundVisible: false
            clearButtonVisible: false

            input {
                submitKey: SubmitKey.Done
                flags: TextInputFlag.SpellCheckOff | TextInputFlag.AutoCapitalizationOff
                keyLayout: KeyLayout.EmailAddress

                onSubmitted: {
                    inputNumber.loseFocus();
                }
            }
        }

        Container {
            layout: DockLayout {

            }
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            rightPadding: ui.sdu(2)

            ImageButton {
                defaultImageSource: "asset:///images/dialer/backspace_default.png"
                pressedImageSource: "asset:///images/dialer/backspace_over.png"
                disabledImageSource: "asset:///images/dialer/backspace_default.png"
                opacity: inputNumber.text.length > 0 ? 1 : 0.2
                enabled: inputNumber.text.length > 0

                gestureHandlers: [
                    TapHandler {
                        onTapped: {
                            inputNumber.text = inputNumber.text.substring(0, inputNumber.text.length - 1)
                        }
                    },
                    LongPressHandler {
                        onLongPressed: {
                            inputNumber.text = ""
                        }
                    }
                ]
            }
        }
    }

    Numpad {
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
        topPadding: ui.sdu(4)
    }

    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        minHeight: ui.sdu(15)
        visible: ! bps.isKeyboardVisible

        Container {
            layout: DockLayout {

            }
            layoutProperties: StackLayoutProperties {
                spaceQuota: 3
            }
            background: colors.colorF
            verticalAlignment: VerticalAlignment.Fill
            visible: ! inCallModel.isInCall

            onTouch: {
                if (addToContact.opacity == 1) { // Button is enabled, otherwise it is disabled
                    if (event.isDown() || event.isMove()) {
                        background = colors.colorE
                    } else if (event.isUp() || event.isCancel()) {
                        background = colors.colorF
                    }
                }
            }

            onTouchExit: {
                background = colors.colorF
            }

            gestureHandlers: TapHandler {
                onTapped: {
                    if (addToContact.opacity == 1) { // Button is enabled, otherwise it is disabled
                        contactEditorModel.setNextEditSipAddress(inputNumber.text);
                        tabDelegate.source = "contacts/ContactsListView.qml"
                    }
                }
            }

            ImageView {
                id: addToContact
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                imageSource: "asset:///images/contacts/contact_add.png"
                opacity: inputNumber.text.length > 0 ? 1 : 0.2
            }
        }

        Container {
            layout: DockLayout {

            }
            layoutProperties: StackLayoutProperties {
                spaceQuota: 3
            }
            background: colors.colorF
            verticalAlignment: VerticalAlignment.Fill
            visible: inCallModel.isInCall

            onTouch: {
                if (event.isDown() || event.isMove()) {
                    background = colors.colorE
                } else if (event.isUp() || event.isCancel()) {
                    background = colors.colorF
                }
            }

            onTouchExit: {
                background = colors.colorF
            }

            gestureHandlers: TapHandler {
                onTapped: {
                    inCallModel.dialerCallButtonMode = 0;
                    inCallView.open();
                }
            }

            ImageView {
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                imageSource: "asset:///images/dialer/call_back.png"
            }
        }

        Container {
            layout: DockLayout {

            }
            layoutProperties: StackLayoutProperties {
                spaceQuota: 5
            }
            background: colors.colorA
            verticalAlignment: VerticalAlignment.Fill

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
                    if (inputNumber.text.length > 0) {
                        newOutgoingCallOrCallTransfer(inputNumber.text);
                    } else {
                        inputNumber.text = historyListModel.getLatestOutgoingCallAddress();
                    }
                }
            }

            ImageView {
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                imageSource: inCallModel.dialerCallButtonMode == 1 ? "asset:///images/dialer/call_transfer.png" : inCallModel.dialerCallButtonMode == 2 ? "asset:///images/dialer/call_add.png" : "asset:///images/dialer/call_audio_start.png"
            }
        }
    }
}
