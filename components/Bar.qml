// Bar.qml
import "../config"
import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Io

PanelWindow {
    id: root

    signal requestShowPopover(var screen)

    implicitHeight: 65
    color: Colors.transparent

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
            color: Colors.shadow
            cached: true
        }

        Rectangle {
            id: backgroundRect

            anchors.fill: parent
            color: Colors.base
        }

        Rectangle {
            id: bottomBorder

            height: 2
            color: Colors.surface

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
            btnColor: Colors.blue
            scriptPath: "~/.config/hypr/scripts/fuzzel.sh"
            anchors.left: parent.left
        }

        // Workspace Buttons
        Workspaces {
            id: workspacesBar

            anchors {
                left: launcherBtn.right
                verticalCenter: parent.verticalCenter
                leftMargin: -3
            }

        }

        Tray {
            id: systemTray

            anchors {
                left: workspacesBar.right
                verticalCenter: parent.verticalCenter
                rightMargin: -10
            }

        }

        //  Follower
        FollowerWidget {
            id: followerWidget

            screen: root.screen

            anchors {
                horizontalCenter: parent.horizontalCenter
            }

        }

        // Logout Button
        SquareButton {
            id: logoutBtn

            btnText: "󰤆"
            btnColor: Colors.accentRed
            scriptPath: "~/.config/hypr/scripts/wlogout.sh"
            anchors.right: parent.right
        }

        // Time Display
        DisplayButton {
            id: clock

            mainText: Qt.formatTime(new Date(), "HH:mm")
            labelText: "⏰"
            anchors.right: logoutBtn.left
            anchors.rightMargin: -3
            onRequestShowPopover: {
                root.requestShowPopover(root.screen);
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

            mainText: Qt.formatDate(new Date(), "dddd, MMMM dd")
            labelText: "🗓️"
            anchors.right: clock.left
            onRequestShowPopover: {
                root.requestShowPopover(root.screen);
            }

            Timer {
                id: calendarTimer

                interval: 1000
                running: true
                repeat: true
                onTriggered: {
                    calendar.mainText = Qt.formatDate(new Date(), "dddd, MMMM dd");
                }
            }

        }

        // GPU Usage and Temperature
        GpuWidget {
            id: gpu

            anchors.right: calendar.left
            onRequestShowPopover: {
                root.requestShowPopover(root.screen);
            }
        }

        // Memory Usage
        MemoryWidget {
            id: memory

            anchors.right: gpu.left
            onRequestShowPopover: {
                root.requestShowPopover(root.screen);
            }
        }

        // CPU Usage and Temperature
        CpuWidget {
            id: cpu

            anchors.right: memory.left
            onRequestShowPopover: {
                root.requestShowPopover(root.screen);
            }
        }

        // Network Usage
        NetworkWidget {
            id: network

            anchors.right: cpu.left
            onRequestShowPopover: {
                root.requestShowPopover(root.screen);
            }
        }

    }

}
