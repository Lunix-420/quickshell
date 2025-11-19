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

    function getAppIcon(className) {
        if (!className || className === "")
            return "";

        const lookup = DesktopEntries.heuristicLookup(className);
        if (!lookup) {
            console.error("No desktop entry found for " + className);
            return "";
        }
        const icon = lookup.icon;
        if (!icon) {
            console.error("No icon found in desktop entry for " + className);
            return "";
        }
        return Quickshell.iconPath(icon);
    }

    function getTrayIcon(modelData) {
        const icon = modelData.icon;
        const hasPath = icon.indexOf("?path=") !== -1;
        if (!hasPath)
            return icon;

        console.error("Tray icon:", icon + "has ?path=, attempting to resolve");
        const className = modelData.title;
        const lookupIcon = getAppIcon(className);
        console.log("Resolved tray icon for " + className + ": " + lookupIcon);
        return lookupIcon;
    }

    implicitHeight: 55
    implicitWidth: trayRepeater.width

    Rectangle {
        anchors.fill: parent
        color: "#363A4F"
        radius: 18
        anchors.topMargin: 8.5
        anchors.rightMargin: 4
        anchors.leftMargin: 4
        anchors.bottomMargin: 10.5

        Row {
            leftPadding: 10
            spacing: 6

            Repeater {
                id: trayRepeater

                model: SystemTray.items
                implicitWidth: 44 * count

                delegate: Item {
                    implicitHeight: 37
                    implicitWidth: 25

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
