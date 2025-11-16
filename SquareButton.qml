import QtQuick
import QtQuick.Controls
import Quickshell.Io
import QtQuick.Effects

Item {
    id: root

    // Exposed properties for reuse
    property string btnText: "-"
    property string scriptPath: ""
    property string fontSize: "42"
    property string btnColor: "#cad3f5"

    implicitWidth: 65
    implicitHeight: 55

    RectangularShadow {
        anchors.fill: powerBtn
        blur: 10
        spread: 0
        radius: 5
        color: powerBtn.hovered ? btnColor :'#000000'
        cached: true
    }

    Button {
        id: powerBtn
        anchors{
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            topMargin: 5
            rightMargin: 10
            leftMargin: 10
            bottomMargin: 8     
        }

        font.family: "ComicShannsMono Nerd Font Mono"
        font.pixelSize: fontSize
        text: root.btnText  // Use the exposed property

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
            color: powerBtn.hovered ? btnColor :"#363A4F"
            radius: 7             
        }

        onClicked: {
            if (root.scriptPath !== "") {
                scriptRunner.exec({
                    command: ["sh", "-c", root.scriptPath]
                })
            }
        }
    }

    Process {
        id: scriptRunner
        stdout: StdioCollector {
            onStreamFinished: {
                console.log("Output:", text)
            }
        }
        onExited: {
            console.log("Script exited with code", exitCode)
        }
    }
}
