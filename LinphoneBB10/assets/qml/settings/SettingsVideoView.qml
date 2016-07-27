/*
 * SettingsVideoView.qml
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
    layout: StackLayout {
        orientation: LayoutOrientation.TopToBottom
    }
    horizontalAlignment: HorizontalAlignment.Fill
    id: videoContainer
    
    SettingsToggle {
        text: qsTr("Enabled") + Retranslate.onLanguageChanged
        checked: settingsModel.videoEnabled
        horizontalAlignment: HorizontalAlignment.Fill
        enabled: settingsModel.videoSupported
        
        onToggled: {
            settingsModel.videoEnabled = checked;
        }
    }
    
    SettingsToggle {
        text: qsTr("Show preview") + Retranslate.onLanguageChanged
        checked: settingsModel.previewVisible
        horizontalAlignment: HorizontalAlignment.Fill
        enabled: settingsModel.videoSupported && settingsModel.videoEnabled
        
        onToggled: {
            settingsModel.previewVisible = checked;
        }
    }
    
    SettingsToggle {
        text: qsTr("Initiate video calls") + Retranslate.onLanguageChanged
        checked: settingsModel.outgoingVideoCalls
        horizontalAlignment: HorizontalAlignment.Fill
        enabled: settingsModel.videoSupported && settingsModel.videoEnabled
        
        onToggled: {
            settingsModel.outgoingVideoCalls = checked;
        }
    }
    
    SettingsToggle {
        text: qsTr("Accept incoming video requests") + Retranslate.onLanguageChanged
        checked: settingsModel.incomingVideoCalls
        horizontalAlignment: HorizontalAlignment.Fill
        enabled: settingsModel.videoSupported && settingsModel.videoEnabled
        
        onToggled: {
            settingsModel.incomingVideoCalls = checked;
        }
    }
    
    DropDown {
        title: qsTr("Preferred video size") + Retranslate.onLanguageChanged
        selectedIndex: settingsModel.preferredVideoSize
        enabled: settingsModel.videoSupported && settingsModel.videoEnabled
        options: [
            /*Option {
                text: "720p"
                value: "720p"
            },*/
            Option {
                text: "VGA"
                value: "vga"
            },
            /*Option {
                text: "CIF"
                value: "cif"
            },*/
            Option {
                text: "QVGA"
                value: "qvga"
            }/*,
            Option {
                text: "QCIF"
                value: "qcif"
            }*/
        ]
        onSelectedValueChanged: {
            settingsModel.setPreferredVideoSize(selectedOption.value)
        }
    }
    
    SettingsSubHeader {
        text: qsTr("Codecs") + Retranslate.onLanguageChanged
    }
    
    attachedObjects: [                  
        ComponentDefinition {                      
            id: settingsToggle                       
            source: "CodecSettingsToggle.qml"             
        }
    ]
    
    onCreationCompleted: {
        for (var codec in settingsModel.videoCodecs) {
            var videoCodec = settingsToggle.createObject();
            videoCodec.text = codec;
            videoCodec.checked = settingsModel.videoCodecs[codec][0] == 1;
            videoCodec.mime = settingsModel.videoCodecs[codec][1];
            videoCodec.bitrate = settingsModel.videoCodecs[codec][2];
            videoContainer.add(videoCodec);
        }
    }
}
