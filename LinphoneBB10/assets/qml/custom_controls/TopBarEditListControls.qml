import bb.cascades 1.4

Container {
    property bool selectionEmpty
    
    signal cancelEdit();
    signal selectAll();
    signal deselectAll();
    signal deleteSelected();
    
    layout: StackLayout {
        orientation: LayoutOrientation.LeftToRight
    }
    minHeight: ui.sdu(15)
    background: colors.colorF
    visible: !bps.isKeyboardVisible
    
    TopBarButton {
        imageSource: "asset:///images/cancel_edit.png"
        
        gestureHandlers: TapHandler {
            onTapped: {
                cancelEdit();
            }
        }
    }
    
    Container {
        layoutProperties: StackLayoutProperties {
            spaceQuota: 2
        }
    }
    
    TopBarButton {
        imageSource: "asset:///images/select_all.png"
        visible: selectionEmpty
        
        gestureHandlers: TapHandler {
            onTapped: {
                selectAll();
            }
        }
    }
    
    TopBarButton {
        imageSource: "asset:///images/deselect_all.png"
        visible: !selectionEmpty
        
        gestureHandlers: TapHandler {
            onTapped: {
                deselectAll();
            }
        }
    }
    
    TopBarButton {
        imageSource: "asset:///images/delete.png"
        enabled: !selectionEmpty
        
        gestureHandlers: TapHandler {
            onTapped: {
                if (!selectionEmpty) {
                    deleteSelected();
                }
            }
        }
    }
}