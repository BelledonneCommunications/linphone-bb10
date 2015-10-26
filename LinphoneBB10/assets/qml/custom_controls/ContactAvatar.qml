/*
 * ContactAvatar.qml
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
    property alias imageSource: tracker.imageSource
    property alias filterColor: mask.filterColor
    
    layout: DockLayout {
    
    }
    
    Container {
        layout: DockLayout {
        
        }
        topPadding: 1
        bottomPadding: 1
        leftPadding: 1
        rightPadding: 1
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        ImageView {
            id: contact
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            scalingMethod: ScalingMethod.AspectFill
            imageSource: "asset:///images/avatar.png"
            
            attachedObjects: [
                ImageTracker {
                    id: tracker
                    onStateChanged: {                    
                        if (state == ResourceState.Loaded) {
                            contact.image = tracker.image
                        }
                    }
                }
            ]
         }
     }
    
    ImageView {
        id: mask
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        scalingMethod: ScalingMethod.AspectFill
        imageSource: "asset:///images/avatar_mask.png"
    }
}
