/*
 * ConfirmationDialog.qml
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
    property alias text: label.text
    
    signal cancelActionClicked();
    signal confirmActionClicked();
    
    layout: DockLayout {
    
    }
    id: confirmationDialog
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
            id: label
            textStyle.color: colors.colorH
            textStyle.base: titilliumWeb.style
            multiline: true
            textStyle.textAlign: TextAlign.Center
            horizontalAlignment: HorizontalAlignment.Center
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
                    confirmationDialog.visible = false;
                    cancelActionClicked();
                }
            }
            
            DeleteButton {
                id: confirmAction
                leftMargin: ui.sdu(3)
                onDeleteClicked: {
                    confirmationDialog.visible = false;
                    confirmActionClicked();
                }
            }
        }
    }
}