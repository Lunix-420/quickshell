import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell.Hyprland
import Quickshell.Io

Item {
    id: root

    signal requestShowPopover()

    function getActiveWindowTitle() {
        const activeToplevel = Hyprland.activeToplevel;
        console.log("Active Toplevel:", activeToplevel);
        if (activeToplevel === null || activeToplevel === undefined)
            return "No Active Window";

        return activeToplevel.title;
    }

    implicitWidth: button.implicitWidth + 16
    implicitHeight: 55

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            mainLabel.text = root.getActiveWindowTitle();
        }
    }

    RectangularShadow {
        anchors.fill: button
        blur: 5
        spread: 1
        radius: 20
        color: '#000000'
        cached: true
    }

    Button {
        id: button

        onClicked: {
            requestShowPopover();
        }

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            topMargin: 8.5
            rightMargin: 4
            leftMargin: 4
            bottomMargin: 11
        }

        background: Rectangle {
            id: backgroundRect

            color: "#363A4F"
            radius: 20
        }

        contentItem: Row {
            anchors.centerIn: parent
            spacing: 4

            Text {
                id: emojiLabel

                text: "📣"
                font.family: "ComicShannsMono Nerd Font Mono"
                font.pixelSize: 22
                color: "#cad3f5"
                leftPadding: 5
                topPadding: 4
            }

            Text {
                id: mainLabel

                text: "Firefox Developer Edition"
                font.family: "Comic Sans MS"
                font.pixelSize: 18
                color: "#cad3f5"
                topPadding: 2
            }

        }

    }

}
