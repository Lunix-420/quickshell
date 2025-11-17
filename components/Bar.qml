import Quickshell
import Quickshell.Io

import QtQuick
import QtQuick.Effects

PanelWindow {
    signal displayButtonClicked()

    id: root
    implicitHeight: 65
    color: '#00000000'

    anchors {
        top: true
        left: true
        right: true
    }

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
            id: backgroundRect
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
            height: 2
            color: '#363A4F'
        }

        // Launcher Button
        SquareButton {
            id: launcherBtn
            btnText: "󰣇"
            fontSize: "52"
            btnColor: "#8AADF4"
            scriptPath: "~/.config/hypr/scripts/fuzzel.sh"
            anchors.left: parent.left
        }

        // Logout Button
        SquareButton {
            id: logoutBtn
            btnText: "󰤆"
            btnColor: "#ed8796"
            scriptPath: "~/.config/hypr/scripts/wlogout.sh"
            anchors.right: parent.right
        }

        // Time Display
        DisplayButton {
            id: clock
            mainText: Qt.formatTime(new Date(), "HH:mm")
            labelText: "⏰"
            anchors.right: logoutBtn.left

            Timer {
                id: clockTimer
                interval: 1000
                running: true
                repeat: true
                onTriggered: {
                    clock.mainText = Qt.formatTime(new Date(), "HH:mm")
                }
            }

            onRequestShowPopover: {

                root.displayButtonClicked()
            }
        }

        // Date Display
        DisplayButton {
            id: calendar
            mainText: Qt.formatDate(new Date(), "dddd, MMMM d")
            labelText: "🗓️"
            anchors.right: clock.left

            Timer {
                id: calendarTimer
                interval: 1000
                running: true
                repeat: true
                onTriggered: {
                    calendar.mainText = Qt.formatDate(new Date(), "dddd, MMMM d")
                }
            }

            onRequestShowPopover: {
                root.displayButtonClicked()
            }
        }

        // CPU Usage and Temperature
        DisplayButton {
            id: gpu
            mainText: "25%|38°C"
            labelText: "🖥️"
            anchors.right: calendar.left

            onRequestShowPopover: {
                root.displayButtonClicked()
            }
        }

        // GPU Usage and Temperature
        DisplayButton {
            id: cpu
            mainText: "25%|38°C"
            labelText: "🧠"
            anchors.right: gpu.left

            onRequestShowPopover: {
                root.displayButtonClicked()
            }
        }

        // Network Usage
        DisplayButton {
            id: network
            mainText: "120KB/s|1.2MB/s"
            labelText: "🌐"
            anchors.right: cpu.left

            onRequestShowPopover: {
                root.displayButtonClicked()
            }
        }
    }
}