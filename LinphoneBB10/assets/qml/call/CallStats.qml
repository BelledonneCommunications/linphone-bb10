/*
 * CallStats.qml
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
    verticalAlignment: VerticalAlignment.Fill
    minWidth: ui.sdu(75)
    
    Container {
        layout: GridLayout {
            columnCount: 2
        }
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        
        Label {
            text: qsTr("Audio codec") + Retranslate.onLanguageChanged
            horizontalAlignment: HorizontalAlignment.Fill
            textStyle.textAlign: TextAlign.Center
            textStyle.base: titilliumWeb.style
        }
        
        Label {
            text: inCallModel.callStatsModel.audioCodec
            horizontalAlignment: HorizontalAlignment.Fill
            textStyle.textAlign: TextAlign.Center
            textStyle.base: titilliumWeb.style
        }
        
        Label {
            text: qsTr("Video codec") + Retranslate.onLanguageChanged
            horizontalAlignment: HorizontalAlignment.Fill
            textStyle.textAlign: TextAlign.Center
            textStyle.base: titilliumWeb.style
        }
        
        Label {
            text: inCallModel.callStatsModel.videoCodec
            horizontalAlignment: HorizontalAlignment.Fill
            textStyle.textAlign: TextAlign.Center
            textStyle.base: titilliumWeb.style
        }
        
        Label {
            text: qsTr("Audio bandwidth") + Retranslate.onLanguageChanged
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Center
            textStyle.textAlign: TextAlign.Center
            textStyle.base: titilliumWeb.style
        }
        
        Container {
            layout: GridLayout {
                columnCount: 1
            }
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Center
            
            Label {
                text: inCallModel.callStatsModel.downloadAudioBandwidth
                horizontalAlignment: HorizontalAlignment.Fill
                textStyle.textAlign: TextAlign.Center
                textStyle.base: titilliumWeb.style
            }
            
            Label {
                text: inCallModel.callStatsModel.uploadAudioBandwidth
                horizontalAlignment: HorizontalAlignment.Fill
                textStyle.textAlign: TextAlign.Center
                textStyle.base: titilliumWeb.style
            }
        }
        
        Label {
            text: qsTr("Video bandwidth") + Retranslate.onLanguageChanged
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Center
            textStyle.textAlign: TextAlign.Center
            textStyle.base: titilliumWeb.style
        }
        
        Container {
            layout: GridLayout {
                columnCount: 1
            }
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Center
            
            Label {
                text: inCallModel.callStatsModel.downloadVideoBandwidth
                horizontalAlignment: HorizontalAlignment.Fill
                textStyle.textAlign: TextAlign.Center
                textStyle.base: titilliumWeb.style
            }
            
            Label {
                text: inCallModel.callStatsModel.uploadVideoBandwidth
                horizontalAlignment: HorizontalAlignment.Fill
                textStyle.textAlign: TextAlign.Center
                textStyle.base: titilliumWeb.style
            }
        }
        
        Label {
            text: qsTr("Received video size") + Retranslate.onLanguageChanged
            horizontalAlignment: HorizontalAlignment.Fill
            textStyle.textAlign: TextAlign.Center
            textStyle.base: titilliumWeb.style
        }
        
        Label {
            text: inCallModel.callStatsModel.receivedVideoSize
            horizontalAlignment: HorizontalAlignment.Fill
            textStyle.textAlign: TextAlign.Center
            textStyle.base: titilliumWeb.style
        }
        
        Label {
            text: qsTr("Sent video size") + Retranslate.onLanguageChanged
            horizontalAlignment: HorizontalAlignment.Fill
            textStyle.textAlign: TextAlign.Center
            textStyle.base: titilliumWeb.style
        }
        
        Label {
            text: inCallModel.callStatsModel.sentVideoSize
            horizontalAlignment: HorizontalAlignment.Fill
            textStyle.textAlign: TextAlign.Center
            textStyle.base: titilliumWeb.style
        }
        
        Label {
            text: qsTr("Ice connectivity") + Retranslate.onLanguageChanged
            horizontalAlignment: HorizontalAlignment.Fill
            textStyle.textAlign: TextAlign.Center
            textStyle.base: titilliumWeb.style
        }
        
        Label {
            text: inCallModel.callStatsModel.iceStatus
            horizontalAlignment: HorizontalAlignment.Fill
            textStyle.textAlign: TextAlign.Center
            textStyle.base: titilliumWeb.style
        }
    }
}
