/*
 * SideMenu.qml
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
        },
        ComponentDefinition {                      
            id: sideMenuAccountItem                       
            source: "SideMenuAccountItem.qml"             
        },
        ComponentDefinition {                      
            id: customDivider                       
            source: "../custom_controls/CustomDivider.qml"             
        }
    ]
    
    function displaySipAccountsOtherThanDefaultOne() {
        otherAccountsContainer.removeAll();
        
        for (var sipAccount in menuModel.sipAccounts) {
            var account = sideMenuAccountItem.createObject();
            account.text = sipAccount;
            account.imageSource = menuModel.sipAccounts[sipAccount];
            otherAccountsContainer.add(account);
            
            var divider = customDivider.createObject();
            otherAccountsContainer.add(divider);
        }
    }
    
    function updateSideMenuAccountsDisplay() {
        menuModel.updateAccount();
    }
    
    onCreationCompleted: {
        settingsModel.accountSettingsModel.accountUpdated.connect(updateSideMenuAccountsDisplay);
        statusbar.menuOpened.connect(displaySipAccountsOtherThanDefaultOne);
    }

    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        background: colors.colorF
        leftPadding: ui.sdu(2)
        minHeight: ui.sdu(21)
        maxWidth: ui.sdu(75)
        horizontalAlignment: HorizontalAlignment.Fill

        ContactAvatar {
            imageSource: menuModel.photo
            maxHeight: ui.sdu(13)
            minHeight: ui.sdu(13)
            maxWidth: ui.sdu(13)
            minWidth: ui.sdu(13)
            verticalAlignment: VerticalAlignment.Center
            filterColor: colors.colorF
            
            gestureHandlers: TapHandler {
                onTapped: {
                    filePicker.open();
                }
            }
        }

        Container {
            layout: DockLayout {
                
            }
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
            verticalAlignment: VerticalAlignment.Center
            leftPadding: ui.sdu(1)
            
            gestureHandlers: TapHandler {
                onTapped: {
                    if (menuModel.sipUri.length > 0) {
                        settingsModel.accountSettingsModel.selectDefaultProxy();
                        var accountPage = accountSettings.createObject();
                        navigationPane.push(accountPage);
                    }
                }
            }

            Label {
                text: menuModel.displayName
                textStyle.color: colors.colorC
                textStyle.fontWeight: FontWeight.Bold
                textStyle.base: titilliumWeb.style
                textStyle.fontSize: FontSize.Medium
                verticalAlignment: VerticalAlignment.Top
            }
            
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                topPadding: ui.sdu(6)
                rightPadding: ui.sdu(2)
                
                Label {
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1
                    }
                    textStyle.color: colors.colorA
                    text: menuModel.sipUri
                    textStyle.base: titilliumWeb.style
                    textStyle.fontSize: FontSize.Small
                    verticalAlignment: VerticalAlignment.Center
                }
                
                ImageView {
                    scalingMethod: ScalingMethod.AspectFit
                    imageSource: linphoneManager.registrationStatusImage
                    verticalAlignment: VerticalAlignment.Center
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
            
            Container {
                id: otherAccountsContainer
                horizontalAlignment: HorizontalAlignment.Fill
            }
            
            SideMenuItem {
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
            
            SideMenuItem {
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
            
            SideMenuItem {
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
