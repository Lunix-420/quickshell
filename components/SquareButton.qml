import "../config" as Config
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell.Io

Item {
    id: root

    property string btnText: "-"
    property string scriptPath: ""
    property string fontSize: "42"
    property color btnColor: Config.Colors.text

    implicitWidth: 61
    implicitHeight: 55

    RectangularShadow {
        anchors.fill: button
        blur: 5
        spread: 1
        radius: 5
        color: button.hovered ? btnColor : Config.Colors.shadow
        cached: true
    }

    Button {
        id: button

        font.family: "ComicShannsMono Nerd Font Mono"
        font.pixelSize: fontSize
        text: root.btnText // Use the exposed property
        onClicked: {
            if (root.scriptPath !== "")
                scriptRunner.exec({
                "command": ["sh", "-c", root.scriptPath]
            });

        }

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            topMargin: 5
            rightMargin: 8
            leftMargin: 8
            bottomMargin: 8
        }

        contentItem: Text {
            text: button.text
            font: button.font
            color: button.hovered ? Config.Colors.textDark : Config.Colors.text
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            topPadding: 2
        }

        background: Rectangle {
            id: backgroundRect

            color: button.hovered ? btnColor : Config.Colors.surface0
            radius: 7
        }

    }

    Process {
        id: scriptRunner

        onExited: {
            console.log("Script exited with code", exitCode);
        }

        stdout: StdioCollector {
            onStreamFinished: {
                console.log("Output:", text);
            }
        }

    }

}
