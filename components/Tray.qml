import "../config"
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

    function getTrayIcon(modelData) {
        const id = modelData.id;
        let icon = modelData.icon;
        // 1. Check manual overrides in iconSubs
        const iconSubs = [];
        for (const sub of iconSubs) {
            if (sub.id === id)
                return sub.image ? Qt.resolvedUrl(sub.image) : Quickshell.iconPath(sub.icon);

        }
        // 2. Handle ?path= icons
        if (icon.includes("?path=")) {
            const [name, path] = icon.split("?path=");
            icon = Qt.resolvedUrl(`${path}/${name.slice(name.lastIndexOf("/") + 1)}`);
        }
        // 3. Return the processed icon
        return icon;
    }

    implicitHeight: 55
    implicitWidth: trayRow.width + 38

    PanelWindow {
        id: panelWindow

        visible: false
    }

    RectangularShadow {
        anchors.fill: trayBar
        blur: 5
        spread: 1
        radius: 20
        color: Colors.shadow
        cached: true
    }

    Rectangle {
        id: trayBar

        anchors.fill: parent
        color: Colors.surface
        radius: 18
        anchors.topMargin: 8.5
        anchors.rightMargin: 4
        anchors.leftMargin: 4
        anchors.bottomMargin: 10.5

        Row {
            id: trayRow

            spacing: 8
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                anchors.fill: parent
                model: SystemTray.items

                delegate: Item {
                    id: trayItem

                    implicitHeight: 39
                    implicitWidth: 24

                    IconImage {
                        source: getTrayIcon(modelData)
                        anchors.fill: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: (mouse) => {
                            if (mouse.button == Qt.RightButton) {
                                console.log("Right click on tray item:", modelData.id);
                                const baseX = 615;
                                const offsetX = index * 32;
                                const totalX = baseX + offsetX;
                                modelData.display(panelWindow, totalX, 25);
                            }
                            if (mouse.button == Qt.LeftButton)
                                modelData.activate();

                        }
                    }

                }

            }

        }

    }

}
