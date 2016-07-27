/*
 * ChatBubbleOutgoingView.qml
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

import "../custom_controls"

Container {
    property alias imageSource: photo.imageSource
    
    id: itemRoot
    leftPadding: ui.sdu(10)
    rightPadding: ui.sdu(2)
    bottomPadding: ui.sdu(1)
    topPadding: ui.sdu(1)
    preferredWidth: ui.sdu(120)
    
    contextActions: [
        ActionSet {
            title: qsTr("Message") + Retranslate.onLanguageChanged
            ActionItem {
                title: qsTr("Copy to clipboard") + Retranslate.onLanguageChanged
                
                onTriggered: {
                    itemRoot.ListItem.view.copyToClipboard(ListItemData.text);
                }
            }
        }
    ]
    
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        horizontalAlignment: HorizontalAlignment.Right
        
        Container {
            layout: DockLayout {
                
            }

            Container {
                background: Qt.colors.colorA
                opacity: 0.15
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill
            }
            
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight
                }
                verticalAlignment: VerticalAlignment.Center
                bottomPadding: ui.sdu(2)
                rightPadding: ui.sdu(2)
                topPadding: ui.sdu(2)
                leftPadding: ui.sdu(2)
                
                ContactAvatar {
                    id: photo
                    filterColor: Qt.colors.colorA15 
                    imageSource: ListItemData.contactPhoto
                    maxHeight: ui.sdu(13)
                    minHeight: ui.sdu(13)
                    maxWidth: ui.sdu(13)
                    minWidth: ui.sdu(13)
                }
                
                Container {
                    layout: DockLayout {
                    
                    }
                    verticalAlignment: VerticalAlignment.Fill
                    leftPadding: ui.sdu(2)
                    
                    Label {
                        text: ListItemData.timeAndFrom
                        textStyle.base: Qt.titilliumWeb.style
                        textStyle.color: Qt.colors.colorA
                        verticalAlignment: VerticalAlignment.Top
                    }
                    
                    Container {
                        verticalAlignment: VerticalAlignment.Bottom
                        topPadding: ui.sdu(6)
                        
                        Label {
                            text: ListItemData.text
                            visible: !ListItemData.isFileTransferMessage
                            textStyle.fontSize: FontSize.Small
                            textStyle.base: Qt.titilliumWeb.style
                            textStyle.color: Qt.colors.colorD
                            multiline: true
                        }
                        
                        ImageView {
                            id: sentImage
                            visible: ListItemData.isFileTransferMessage
                            scalingMethod: ScalingMethod.AspectFit
                            maxWidth: ui.sdu(30)
                            maxHeight: ui.sdu(30)
                            
                            gestureHandlers: TapHandler {
                                onTapped: {
                                    itemRoot.ListItem.view.openPicture(ListItemData.imageSource);
                                }
                            }
                            
                            attachedObjects: [
                                ImageTracker {
                                    id: tracker
                                    imageSource: ListItemData.imageSource ? ListItemData.imageSource : ""
                                    onStateChanged: {                    
                                        if (state == ResourceState.Loaded) {
                                            sentImage.image = tracker.image
                                        }
                                    }
                                }
                            ]
                        }
                        
                        FileTransferCancelButton {
                            visible: ListItemData.isFileTransferMessage && !ListItemData.isTransferComplete && ListItemData.transferProgress > 0
                        }
                        
                        Container {
                            layout: StackLayout {
                                orientation: LayoutOrientation.TopToBottom
                            }
                            visible: ListItemData.isFileTransferMessage && !ListItemData.isTransferComplete && ListItemData.transferProgress > 0
                            verticalAlignment: VerticalAlignment.Center
                            
                            Label {
                                text: ListItemData.transferProgressText
                                textStyle.base: Qt.titilliumWeb.style
                                textStyle.color: Qt.colors.colorD
                                textStyle.fontSize: FontSize.XSmall
                            }
                            
                            ProgressIndicator {
                                fromValue: 0
                                toValue: 100
                                value: ListItemData.transferProgress
                                maxWidth: ui.sdu(30)
                                state: ListItemData.transferProgressState
                            }
                        }
                    }
                }
                
                ImageView {
                    imageSource: ListItemData.deliveryState
                    verticalAlignment: VerticalAlignment.Top
                    horizontalAlignment: HorizontalAlignment.Right
                    
                    animations: [
                        RotateTransition {
                            id: inProgressRotateAnimation
                            toAngleZ: 360
                            duration: 2000
                            repeatCount: AnimationRepeatCount.Forever
                        }
                    ]
                    
                    onImageSourceChanged: {
                        if (ListItemData.inProgress) {
                            inProgressRotateAnimation.play();
                        } else {
                            inProgressRotateAnimation.stop();
                        }
                    }
                }
            }
            
            Container {
                background: Qt.colors.colorA
                minHeight: 2
                maxHeight: 2
                verticalAlignment: VerticalAlignment.Bottom
                horizontalAlignment: HorizontalAlignment.Fill
            }
        }

        CustomCheckBox {
            
        }
    }
}