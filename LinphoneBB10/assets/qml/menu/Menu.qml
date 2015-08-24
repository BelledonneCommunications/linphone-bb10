/*
 * Menu.qml
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
import bb.cascades.pickers 1.0

import "../custom_controls"

Container {
    verticalAlignment: VerticalAlignment.Fill
    minWidth: ui.sdu(75)
    
    attachedObjects: [
        FilePicker {
            id: filePicker
            type: FileType.Picture
            mode: FilePickerMode.Picker
            imageCropEnabled: true
            title: qsTr("Select picture") + Retranslate.onLanguageChanged
            onFileSelected: {
                menuModel.setPicture(selectedFiles);
            }
        }
    ]

    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        background: colors.colorF
        leftPadding: ui.sdu(2)
        minHeight: ui.sdu(21)
        horizontalAlignment: HorizontalAlignment.Fill

        ContactAvatar {
            imageSource: menuModel.photo
            maxHeight: ui.sdu(13)
            minHeight: ui.sdu(13)
            maxWidth: ui.sdu(13)
            minWidth: ui.sdu(13)
            verticalAlignment: VerticalAlignment.Center
            color: colors.colorF
            
            gestureHandlers: TapHandler {
                onTapped: {
                    filePicker.open();
                }
            }
        }

        Container {
            layout: DockLayout {
                
            }
            verticalAlignment: VerticalAlignment.Center
            leftPadding: ui.sdu(1)

            Label {
                text: menuModel.displayName
                textStyle.color: colors.colorC
                textStyle.fontWeight: FontWeight.Bold
                textStyle.base: titilliumWeb.style
                textStyle.fontSize: FontSize.Medium
                verticalAlignment: VerticalAlignment.Top
            }
            
            Container {
                topPadding: ui.sdu(6)
                
                Label {
                    textStyle.color: colors.colorA
                    text: menuModel.sipUri
                    textStyle.base: titilliumWeb.style
                    verticalAlignment: VerticalAlignment.Bottom
                    textStyle.fontSize: FontSize.Small
                }
            }
        }
    }
    
    ScrollView {
        scrollViewProperties.scrollMode: ScrollMode.Vertical
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        Container {
            background: colors.colorH
            horizontalAlignment: HorizontalAlignment.Fill
            
            CustomDivider {
            
            }
            
            MenuItem {
                text: qsTr("Assistant") + Retranslate.onLanguageChanged
                
                gestureHandlers: TapHandler {
                    onTapped: {
                        var assistantPage = assistant.createObject();
                        navigationPane.push(assistantPage);
                    }
                }
            }
            
            CustomDivider {
                
            }
            
            MenuItem {
                text: qsTr("Settings") + Retranslate.onLanguageChanged
                
                gestureHandlers: TapHandler {
                    onTapped: {
                        var settingsPage = settings.createObject();
                        navigationPane.push(settingsPage);
                    }
                }
            }
            
            CustomDivider {
            
            }
            
            MenuItem {
                text: qsTr("About") + Retranslate.onLanguageChanged
                
                gestureHandlers: TapHandler {
                    onTapped: {
                        var aboutPage = about.createObject();
                        navigationPane.push(aboutPage);
                    }
                }
            }
            
            CustomDivider {
            
            }
        }
    }
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        horizontalAlignment: HorizontalAlignment.Fill
        minHeight: ui.sdu(15)
        background: colors.colorA
        leftPadding: ui.sdu(2)
        
        ImageButton {
            defaultImageSource: "asset:///images/menu/quit_default.png"
            pressedImageSource: "asset:///images/menu/quit_over.png"
            verticalAlignment: VerticalAlignment.Center
            
            onClicked: {
                linphoneManager.exit();
            }
        }
        
        Label {
            text: qsTr("Quit") + Retranslate.onLanguageChanged
            verticalAlignment: VerticalAlignment.Center
            textStyle.color: colors.colorH
            textStyle.base: titilliumWeb.style
        }
    }
}
