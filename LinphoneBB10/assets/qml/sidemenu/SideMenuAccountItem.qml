/*
 * SideMenuAccountItem.qml
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

Container {
    property alias text: menuItem.text
    property alias imageSource: accountRegistrationIcon.imageSource
    
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }
    horizontalAlignment: HorizontalAlignment.Fill
    maxWidth: ui.sdu(75)
    rightPadding: ui.sdu(2)
    background: colors.colorG
    
    SideMenuItem {
        id: menuItem
        layoutProperties: StackLayoutProperties {
            spaceQuota: 1
        }
    }
    
    ImageView {
        id: accountRegistrationIcon
        verticalAlignment: VerticalAlignment.Center
        scalingMethod: ScalingMethod.AspectFit
        imageSource: "asset:///images/presence/status_disconnected.png"
    }
    
    gestureHandlers: TapHandler {
        onTapped: {
            settingsModel.accountSettingsModel.setSelectedAccount(menuItem.text);
            var accountPage = accountSettings.createObject();
            navigationPane.push(accountPage);
        }
    }
    
    function displaySipAccountsOtherThanDefaultOne() {
        otherAccountsContainer.removeAll();
        
        for (var sipAccount in menuModel.sipAccounts) {
            if (sipAccount == menuItem.text) {
                accountRegistrationIcon.imageSource = menuModel.sipAccounts[sipAccount];
            }
        }
    }
    
    onCreationCompleted: {
        linphoneManager.registrationStatusChanged.connect(registrationStatusChanged);
    }
}
