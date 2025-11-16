import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import QtQuick.Controls
import QtQuick.Effects

PanelWindow {
    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 60
    color: '#00000000'

    Item {
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            bottomMargin: 10 
        }

        RectangularShadow {
            anchors.fill: bottomBorder
            offset: Qt.vector2d(0, 3) 
            blur: 10
            spread: 1
            radius: 5
            color: '#000000'         
            cached: true
        }

        Rectangle {
            anchors.fill: parent
            color: "#24273A"
        }

        Rectangle {
            id: bottomBorder
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            height: 3
            color: '#363A4F'
        }

        PowerButton {
            anchors.right: parent.right
        }
    }
}
