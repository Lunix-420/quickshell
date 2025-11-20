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

    implicitWidth: powerBtn.implicitWidth + 16
    implicitHeight: 55

    RectangularShadow {
        anchors.fill: powerBtn
        blur: 5
        spread: 1
        radius: 20
        color: '#000000'
        cached: true
    }

    Button {
        id: powerBtn

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

            color: "#363A4F"
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
                color: "#cad3f5"
                leftPadding: 5
                topPadding: 5
            }

            Text {
                id: mainLabel

                text: mainText
                font.family: "ComicShannsMono Nerd Font Mono"
                font.pixelSize: 16
                color: "#cad3f5"
                topPadding: 7
            }

        }

    }

}
