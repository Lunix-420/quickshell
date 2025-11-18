import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell.Io

Item {
    id: root

    property string btnText: "-"
    property string scriptPath: ""
    property string fontSize: "42"
    property string btnColor: "#cad3f5"

    implicitWidth: 61
    implicitHeight: 55

    RectangularShadow {
        anchors.fill: powerBtn
        blur: 5
        spread: 1
        radius: 5
        color: powerBtn.hovered ? btnColor : '#000000'
        cached: true
    }

    Button {
        id: powerBtn

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
            text: powerBtn.text
            font: powerBtn.font
            color: powerBtn.hovered ? "#181926" : "#cad3f5"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            topPadding: 2
        }

        background: Rectangle {
            id: backgroundRect

            color: powerBtn.hovered ? btnColor : "#363A4F"
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
