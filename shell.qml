import QtQuick
import QtQuick.Controls
import Quickshell
import "components"

ShellRoot {
    id: root

    Variants {
        model: Quickshell.screens

        Bar {
            required property var modelData

            screen: modelData
            onRequestShowPopover: function(screenRef) {
                if (screenRef === undefined || screenRef === null)
                    return ;

                const wasVisible = popover.visible;
                const sameScreen = popover.screen === screenRef;
                if (!wasVisible) {
                    popover.screen = screenRef;
                    popover.visible = true;
                    return ;
                }
                if (sameScreen) {
                    popover.visible = false;
                    return ;
                }
                popover.visible = false;
                popover.screen = screenRef;
                popover.visible = true;
            }
        }

    }

    PanelWindow {
        id: popover

        visible: false
        exclusiveZone: 0
        implicitWidth: 400
        implicitHeight: 300

        anchors {
            top: true
        }

    }

}
