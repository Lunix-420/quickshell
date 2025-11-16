import QtQuick
import QtQuick.Controls
import Quickshell.Io

Item {
    id: root

    // Expose implicit size from the internal Button so the component has a natural size
    implicitWidth: powerBtn.implicitWidth
    implicitHeight: powerBtn.implicitHeight

    Button {
        id: powerBtn
        anchors.fill: parent
        font.family: "monospace"
        text: "⏻"

        onClicked: {
            scriptRunner.exec({
                command: ["sh", "-c", "~/.config/hypr/scripts/wlogout.sh"]
            })
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
