import QtQuick
import QtQuick.Controls
import Quickshell

import "components"

ShellRoot {
    id: root
    Bar { id: bar
        onDisplayButtonClicked: {
            popover.visible = !popover.visible
        }
    }

    PanelWindow {
        id: popover
        visible: false
        exclusiveZone: 0 
        width: 400
        height: 300
        anchors{
            top: true
        }
    }
}