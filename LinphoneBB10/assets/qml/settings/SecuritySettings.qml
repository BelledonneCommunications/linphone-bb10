import bb.cascades 1.4

import "../custom_controls"

Container {
    ExpandableView {
        id: securitySettingsExpander
        maxCollapsedHeight: ui.sdu(12)
        
        collapseMode: CollapseMode.UserCollapse
        expandMode: ExpandMode.UserExpand
        
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
            
            SettingsHeader {
                text: qsTr("SECURITY") + Retranslate.onLanguageChanged
            }
            
            DropDown {
                title: qsTr("Media Encryption")
            }
        }
    }
}
