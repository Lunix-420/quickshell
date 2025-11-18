import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Io

PanelWindow {
    id: root

    signal requestShowPopover()

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

            height: 2
            color: '#363A4F'

            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

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

        // Firefox Title Placeholder
        DisplayButton {
            id: titlePlaceholder

            mainText: "Firefox Devloper Edition"
            labelText: "🌐"
            anchors.horizontalCenter: parent.horizontalCenter
            onRequestShowPopover: {
                root.requestShowPopover();
            }
        }

        // Time Display
        DisplayButton {
            id: clock

            mainText: Qt.formatTime(new Date(), "HH:mm")
            labelText: "⏰"
            anchors.right: logoutBtn.left
            onRequestShowPopover: {
                root.requestShowPopover();
            }

            Timer {
                id: clockTimer

                interval: 1000
                running: true
                repeat: true
                onTriggered: {
                    clock.mainText = Qt.formatTime(new Date(), "HH:mm");
                }
            }

        }

        // Date Display
        DisplayButton {
            id: calendar

            mainText: "We" + Qt.formatDate(new Date(), "dddd, MMMM dd")
            labelText: "🗓️"
            anchors.right: clock.left
            onRequestShowPopover: {
                root.requestShowPopover();
            }

            Timer {
                id: calendarTimer

                interval: 1000
                running: true
                repeat: true
                onTriggered: {
                    calendar.mainText = "We" + Qt.formatDate(new Date(), "dddd, MMMM dd");
                }
            }

        }

        // GPU Usage and Temperature
        GpuWidget {
            id: gpu

            anchors.right: calendar.left
            onRequestShowPopover: {
                root.requestShowPopover();
            }
        }

        // Memory Usage
        MemoryWidget {
            id: memory

            anchors.right: gpu.left
            onRequestShowPopover: {
                root.requestShowPopover();
            }
        }

        // CPU Usage and Temperature
        CpuWidget {
            id: cpu

            anchors.right: memory.left
            onRequestShowPopover: {
                root.requestShowPopover();
            }
        }

        // Network Usage
        NetworkWidget {
            id: network

            anchors.right: cpu.left
            onRequestShowPopover: {
                root.requestShowPopover();
            }
        }

    }

}
