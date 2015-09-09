/*
 * TabBar.qml
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
    id: tabs
    minHeight: ui.sdu(15)
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }

    TabBarItem {
        id: history
        imageSource: "asset:///images/footer_history.png"
        verticalAlignment: VerticalAlignment.Fill
        badgeValue: linphoneManager.unreadMissedCalls

        onTouch: {
            var currentlySelectedTab = getCurrentlySelectedTab()
            if (event.isDown() || event.isMove()) {
                background = colors.colorA
            } else if (event.isUp() || event.isCancel()) {
                resetAllTabsBackgroundColor()
                if (event.isUp()) {
                    selected = true
                    linphoneManager.resetUnreadMissedCallsCount()
                    tabDelegate.source = "../history/HistoryListView.qml"
                } else {
                    currentlySelectedTab.selected = true
                }
            }
        }
        
        onTouchExit: {
            background = colors.colorC
        }
    }

    TabBarItem {
        id: contacts
        imageSource: "asset:///images/footer_contacts.png"
        verticalAlignment: VerticalAlignment.Fill

        onTouch: {
            var currentlySelectedTab = getCurrentlySelectedTab()
            if (event.isDown() || event.isMove()) {
                background = colors.colorA
            } else if (event.isUp() || event.isCancel()) {
                resetAllTabsBackgroundColor()
                if (event.isUp()) {
                    selected = true
                    tabDelegate.source = "../contacts/ContactsListView.qml"
                } else {
                    currentlySelectedTab.selected = true
                }
            }
        }
        
        onTouchExit: {
            background = colors.colorC
        }
    }

    TabBarItem {
        id: dialer
        imageSource: "asset:///images/footer_dialer.png"
        verticalAlignment: VerticalAlignment.Fill
        selected: true

        onTouch: {
            var currentlySelectedTab = getCurrentlySelectedTab()
            if (event.isDown() || event.isMove()) {
                background = colors.colorA
            } else if (event.isUp() || event.isCancel()) {
                resetAllTabsBackgroundColor()
                if (event.isUp()) {
                    selected = true
                    tabDelegate.source = "../DialerView.qml"
                } else {
                    currentlySelectedTab.selected = true
                }
            }
        }
        
        onTouchExit: {
            background = colors.colorC
        }
    }

    TabBarItem {
        id: chat
        imageSource: "asset:///images/footer_chat.png"
        verticalAlignment: VerticalAlignment.Fill
        badgeValue: linphoneManager.unreadChatMessages

        onTouch: {
            var currentlySelectedTab = getCurrentlySelectedTab()
            if (event.isDown() || event.isMove()) {
                background = colors.colorA
            } else if (event.isUp() || event.isCancel()) {
                resetAllTabsBackgroundColor()
                if (event.isUp()) {
                    selected = true
                    tabDelegate.source = "../chat/ChatListView.qml"
                } else {
                    currentlySelectedTab.selected = true
                }
            }
        }
        
        onTouchExit: {
            background = colors.colorC
        }
    }
    
    function resetAllTabsBackgroundColor() {
        chat.background = colors.colorC
        chat.selected = false
        dialer.background = colors.colorC
        dialer.selected = false
        contacts.background = colors.colorC
        contacts.selected = false
        history.background = colors.colorC
        history.selected = false
    }
    
    function getCurrentlySelectedTab() {
        if (chat.selected)
            return chat
        if (dialer.selected)
            return dialer
        if (contacts.selected)
            return contacts
        if (history.selected)
            return history
    }
    
    function setChatTabSelected() {
        resetAllTabsBackgroundColor();
        chat.selected = true;
    }
}