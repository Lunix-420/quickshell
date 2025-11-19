import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.SystemTray
import Quickshell.Widgets

Item {
    id: root

    implicitHeight: 55
    implicitWidth: trayRepeater.width

    Rectangle {
        anchors.fill: parent
        color: '#340022ff'
    }

    Row {
        spacing: 0

        Repeater {
            id: trayRepeater

            model: SystemTray.items
            implicitWidth: 44 * count

            Item {
                implicitHeight: 55
                implicitWidth: 44

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 32
                    height: 32
                    color: '#1bff0000'
                }

                IconImage {
                    source: model.icon
                    anchors.fill: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        model.activate();
                    }
                    onPressed: {
                        if (model.hasMenu)
                            model.display(parent, 0, parent.height);

                    }
                }

            }

        }

    }

}
