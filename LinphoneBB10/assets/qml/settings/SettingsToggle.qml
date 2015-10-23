/*
 * SettingsToggle.qml
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
    property alias text: label.text
    property alias checked: toggle.checked
    
    signal toggled(bool checked);
    
    layout: DockLayout {
    
    }
    id: parent
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Center
    topPadding: ui.sdu(1)
    bottomPadding: ui.sdu(1)
    
    Label {
        id: label
        horizontalAlignment: HorizontalAlignment.Left
        verticalAlignment: VerticalAlignment.Center
        textStyle.base: titilliumWeb.style
    }
    
    ToggleButton {
        id: toggle
        horizontalAlignment: HorizontalAlignment.Right
        verticalAlignment: VerticalAlignment.Center
        enabled: parent.enabled
        
        onCheckedChanged: {
            toggled(checked);
        }
    }
}
