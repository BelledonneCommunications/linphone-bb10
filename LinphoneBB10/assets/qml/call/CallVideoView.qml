/*
 * CallVideo.qml
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
    layout: DockLayout {

    }
    horizontalAlignment: HorizontalAlignment.Fill
    verticalAlignment: VerticalAlignment.Fill

    ForeignWindowControl {
        windowId: "LinphoneVideoWindowId" // Do not change the name of this windowId
        visible: boundToWindow // becomes visible once bound to a window
        updatedProperties: WindowProperty.Position | WindowProperty.Size
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill

        onCreationCompleted: {
            inCallModel.onVideoSurfaceCreationCompleted(windowId, windowGroup);
        }

        gestureHandlers: TapHandler {
            onTapped: {
                inCallModel.switchFullScreenMode();
            }
        }
    }

    ForeignWindowControl {
        windowId: "LinphoneLocalVideoWindowId" // Do not change the name of this windowId
        visible: settingsModel.previewVisible && boundToWindow // becomes visible once bound to a window
        updatedProperties: WindowProperty.Position | WindowProperty.Size | WindowProperty.Visible
        horizontalAlignment: HorizontalAlignment.Right
        verticalAlignment: VerticalAlignment.Bottom
        preferredWidth: inCallModel.previewSize.width
        preferredHeight: inCallModel.previewSize.height

        onWindowAttached: {
            inCallModel.cameraPreviewAttached(windowHandle)
        }
    }
}