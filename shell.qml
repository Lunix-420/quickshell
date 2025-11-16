import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import QtQuick.Controls
import QtQuick.Effects
import "components"

PanelWindow {
    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 65
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

        SquareButton {
            id: launcherBtn
            btnText: "󰣇"
            fontSize: "52"
            btnColor: "#8AADF4"
            scriptPath: "~/.config/hypr/scripts/fuzzel.sh"
            anchors.left: parent.left
        }

        SquareButton {
            id: logoutBtn
            btnText: "󰤆"
            btnColor: "#ed8796"
            scriptPath: "~/.config/hypr/scripts/wlogout.sh"
            anchors.right: parent.right
        }

        DisplayButton {
            id: clock
            mainText: Qt.formatTime(new Date(), "HH:mm")
            labelText: "⏰"
            anchors.right: logoutBtn.left
        }

        DisplayButton {
            id: calendar
            mainText: Qt.formatDate(new Date(), "dddd, MMMM d")
            labelText: "🗓️"
            anchors.right: clock.left
        }
    }
}
