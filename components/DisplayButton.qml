import "../config" as Config
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell.Io

Item {
    id: root

    property string scriptPath: ""
    property string mainText: "-"
    property string labelText: "-"

    signal requestShowPopover()

    implicitWidth: button.implicitWidth + 16
    implicitHeight: 55

    RectangularShadow {
        anchors.fill: button
        blur: 5
        spread: 1
        radius: 20
        color: Config.Colors.shadow
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
            bottomMargin: 10.5
        }

        background: Rectangle {
            id: backgroundRect

            color: Config.Colors.surface0
            radius: 20
        }

        contentItem: Row {
            anchors.centerIn: parent
            spacing: 4

            Text {
                id: emojiLabel

                text: labelText
                font.family: "ComicShannsMono Nerd Font Mono"
                font.pixelSize: 20
                color: Config.Colors.text
                leftPadding: 5
                topPadding: 5
            }

            Text {
                id: mainLabel

                text: mainText
                font.family: "ComicShannsMono Nerd Font Mono"
                font.pixelSize: 16
                color: Config.Colors.text
                topPadding: 7
            }

        }

    }

}
