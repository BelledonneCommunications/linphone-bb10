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
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
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
    
    DropDown {
        title: qsTr("Preferred video size") + Retranslate.onLanguageChanged
        selectedIndex: settingsModel.preferredVideoSize
        options: [
            Option {
                text: "720p"
                value: "720p"
            },
            Option {
                text: "VGA"
                value: "vga"
            },
            Option {
                text: "CIF"
                value: "cif"
            },
            Option {
                text: "QVGA"
                value: "qcif"
            },
            Option {
                text: "QCIF"
                value: "qvga"
            }
        ]
        onSelectedValueChanged: {
            settingsModel.setPreferredVideoSize(selectedOption.value)
        }
    }
    
    attachedObjects: [                  
        ComponentDefinition {                      
            id: settingsToggle                       
            source: "../custom_controls/CodecSettingsToggle.qml"             
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
