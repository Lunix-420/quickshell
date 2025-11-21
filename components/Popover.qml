import QtQuick
import QtQuick.Controls
import Quickshell
import "../components"
import "../config"

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
