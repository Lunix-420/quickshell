// color:

import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell.Hyprland
import Quickshell.Io

Item {
    function numbersToKanji(num) {
        const map = {
            "1": "一",
            "2": "二",
            "3": "三",
            "4": "四",
            "5": "五",
            "6": "六",
            "7": "七",
            "8": "八",
            "9": "九",
            "10": "百",
            "11": "千",
            "12": "万"
        };
        return map[num] || num.toString();
    }

    implicitHeight: 55
    implicitWidth: workspaceRepeater.width
    Component.onCompleted: {
        Hyprland.refreshWorkspaces();
    }

    Row {
        spacing: 0

        Repeater {
            id: workspaceRepeater

            model: Hyprland.workspaces
            implicitWidth: 44 * count

            Item {
                implicitHeight: 55
                implicitWidth: 44

                RectangularShadow {
                    anchors.fill: workspaceButton
                    blur: 5
                    spread: 1
                    radius: 18
                    color: modelData.active ? "#cad3f5" : '#000000'
                    cached: true
                }

                Button {
                    id: workspaceButton

                    onClicked: {
                        modelData.activate();
                    }

                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                        topMargin: 8.5
                        rightMargin: 4
                        leftMargin: 4
                        bottomMargin: 10.5
                    }

                    background: Rectangle {
                        id: backgroundRect

                        color: (modelData.urgent) ? "#ed8796" : (modelData.active) ? "#cad3f5" : "#363A4F"
                        radius: 18
                    }

                    contentItem: Text {
                        id: mainLabel

                        text: numbersToKanji(modelData.id)
                        font.family: "ComicShannsMono Nerd Font Mono"
                        font.weight: Font.Normal
                        font.pixelSize: 18
                        color: (modelData.active || modelData.urgent) ? "#181926" : "#cad3f5"
                        topPadding: 1.5
                        leftPadding: 5
                    }

                }

            }

        }

    }

    // Update workspaces when Hyprland events come in
    Connections {
        function onRawEvent() {
            Hyprland.refreshWorkspaces();
        }

        target: Hyprland
    }

}
