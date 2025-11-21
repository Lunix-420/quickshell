//@ pragma UseQApplication
//@ pragma Env QSG_RENDER_LOOP=threaded

import QtQuick
import QtQuick.Controls
import Quickshell
import "components"
import "config"

ShellRoot {
    id: root

    property var popoverAnchor: null

    Variants {
        id: screens

        model: Quickshell.screens

        Bar {
            id: bar

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
        // Rectangle {
        //     id: cpuPopoverContent
        //     implicitHeight: 300
        //     implicitWidth: 400
        // }
        // Rectangle {
        //     id: gpuPopoverContent
        //     implicitHeight: 300
        //     implicitWidth: 400
        // }

        id: popover

        visible: false
        exclusiveZone: 0
        implicitWidth: 400
        implicitHeight: 300
        color: Colors.overlayDim

        anchors {
            top: true
            left: true
            right: true
        }

        margins {
            top: -12
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                popover.visible = false;
            }
        }

    }

}
