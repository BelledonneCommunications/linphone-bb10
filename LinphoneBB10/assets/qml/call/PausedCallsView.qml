/*
 * PausedCallsView.qml
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
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import bb.cascades 1.4

Container {
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Bottom
    
    onCreationCompleted: {
        // This is a needed hack since listeItemComponents are created in a different context,
        // so colors and fonts aren't available
        Qt.colors = colors
        Qt.titilliumWeb = titilliumWeb
    }
    
    ListView {
        layout: StackListLayout {
            headerMode: ListHeaderMode.None
            orientation: LayoutOrientation.BottomToTop
        }
        dataModel: inCallModel.pausedCallsDataModel
        stickToEdgePolicy: ListViewStickToEdgePolicy.End
        scrollIndicatorMode: ScrollIndicatorMode.None
        preferredHeight: inCallModel.pausedCallsDataModel.childCount(0) * ui.sdu(15) // To ensure the height of the listview is the strict required to not overlap over any other control (that would cause it to be not clickable)
        
        function itemType(data, indexPath) {
            return "paused_call";
        }
        
        function resumeCall(callModel) {
            inCallModel.resumeCall(callModel);
        }
        
        listItemComponents: [
            ListItemComponent {
                type: "paused_call"
                
                PausedCall {
                
                }
            }
        ]
    }
}
