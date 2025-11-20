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

    RectangularShadow {
        anchors.fill: trayBar
        blur: 5
        spread: 1
        radius: 20
        color: '#000000'
        cached: true
    }

    Rectangle {
        id: trayBar

        anchors.fill: parent
        color: "#363A4F"
        radius: 18
        anchors.topMargin: 8.5
        anchors.rightMargin: 4
        anchors.leftMargin: 4
        anchors.bottomMargin: 10.5

        Row {
            id: trayRow

            spacing: 8
            anchors.horizontalCenter: parent.horizontalCenter
            LayoutMirroring.enabled: true
            LayoutMirroring.childrenInherit: true

            Repeater {
                id: trayRepeater

                anchors.fill: parent
                model: SystemTray.items

                delegate: Item {
                    implicitHeight: 39
                    implicitWidth: 24

                    IconImage {
                        source: getTrayIcon(modelData)
                        anchors.fill: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            modelData.activate();
                        }
                        onPressed: {
                            if (modelData.hasMenu)
                                modelData.display(parent, 0, parent.height);

                        }
                    }

                }

            }

        }

    }

}
