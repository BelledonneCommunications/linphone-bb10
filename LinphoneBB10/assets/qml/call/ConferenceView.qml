/*
 * ConferenceView.qml
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

import "../custom_controls"

Container {
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Top
    background: colors.colorH
    
    onCreationCompleted: {
        // This is a needed hack since listeItemComponents are created in a different context,
        // so colors and fonts aren't available
        Qt.colors = colors
        Qt.titilliumWeb = titilliumWeb
    }
    
    Container {
        minHeight: ui.sdu(15)
        leftPadding: ui.sdu(2)
        
        Label {
            text: qsTr("Conference") + Retranslate.onLanguageChanged
            textStyle.fontWeight: FontWeight.Normal
            textStyle.base: titilliumWeb.style
            textStyle.color: colors.colorC
            textStyle.fontSize: FontSize.XXLarge
        }
    }
    
    CustomDivider {
        
    }
    
    ListView {
        layout: StackListLayout {
            headerMode: ListHeaderMode.None
            orientation: LayoutOrientation.TopToBottom
        }
        dataModel: inCallModel.conferenceCallsDataModel
        scrollIndicatorMode: ScrollIndicatorMode.None
        
        function itemType(data, indexPath) {
            return "conference_call";
        }
        
        function ejectFromConference(callModel) {
            inCallModel.ejectFromConference(callModel);
        }
        
        listItemComponents: [
            ListItemComponent {
                type: "conference_call"
                
                ConferenceCall {
                
                }
            }
        ]
    }
}
