/*
 * CurrentCallHeaderView.qml
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
import org.linphone 1.0

import "../custom_controls"

Container {
    property alias title: displayName.text
    property alias subtitle: callTimeOrSipUri.text
    
    layout: DockLayout {

    }
    verticalAlignment: VerticalAlignment.Top
    horizontalAlignment: HorizontalAlignment.Fill
    minHeight: ui.sdu(19)
    maxHeight: ui.sdu(19)
    touchPropagationMode: TouchPropagationMode.None

    Container {
        background: colors.colorH
        opacity: 0.7
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
    }

    Container {
        layout: DockLayout {

        }
        verticalAlignment: VerticalAlignment.Center
        horizontalAlignment: HorizontalAlignment.Center

        Label {
            id: displayName
            horizontalAlignment: HorizontalAlignment.Center
            textStyle.fontSize: FontSize.XLarge
            textStyle.color: colors.colorC
            textStyle.base: titilliumWeb.style
        }

        Container {
            horizontalAlignment: HorizontalAlignment.Center
            topPadding: ui.sdu(8)

            Label {
                id: callTimeOrSipUri
                horizontalAlignment: HorizontalAlignment.Center
                textStyle.color: colors.colorA
                textStyle.base: titilliumWeb.style
            }
        }
    }
}