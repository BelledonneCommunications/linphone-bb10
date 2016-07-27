/*
 * TopBarEditListControls.qml
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
    property int selectionSize : 0
    property int itemsCount : 0
    
    signal cancelEdit();
    signal selectAll();
    signal deselectAll();
    signal deleteSelected();
    
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }
    minHeight: ui.sdu(15)
    background: colors.colorF
    visible: !bps.isKeyboardVisible
    
    TopBarButton {
        imageSource: "asset:///images/cancel_edit.png"
        
        gestureHandlers: TapHandler {
            onTapped: {
                cancelEdit();
            }
        }
    }
    
    Container {
        layoutProperties: StackLayoutProperties {
            spaceQuota: 2
        }
    }
    
    TopBarButton {
        imageSource: "asset:///images/select_all.png"
        visible: selectionSize < itemsCount
        
        gestureHandlers: TapHandler {
            onTapped: {
                selectAll();
            }
        }
    }
    
    TopBarButton {
        imageSource: "asset:///images/deselect_all.png"
        visible: selectionSize == itemsCount
        
        gestureHandlers: TapHandler {
            onTapped: {
                deselectAll();
            }
        }
    }
    
    TopBarButton {
        imageSource: "asset:///images/delete.png"
        enabled: selectionSize > 0
        
        gestureHandlers: TapHandler {
            onTapped: {
                if (selectionSize > 0) {
                    deleteSelected();
                }
            }
        }
    }
}