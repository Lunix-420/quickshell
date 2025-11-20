import "../config"
import "../services"
import "../utils"
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell.Io

Item {
    id: root

    signal requestShowPopover()

    function formatText(memoryUsage) {
        const usageInGiB = Bytes.toGibiBytes(memoryUsage).toFixed(1);
        const usageString = Strings.leftPad(usageInGiB, 4, " ");
        return usageString + "GB";
    }

    width: memory.implicitWidth
    height: memory.implicitHeight
    Component.onCompleted: updateMainText()

    DisplayButton {
        id: memory

        mainText: formatText(MemoryStats.memoryUsage)
        labelText: "🧠"
        onRequestShowPopover: {
            root.requestShowPopover();
        }
    }

    Connections {
        target: MemoryStats
        onMemoryUsageChanged: updateMainText()
    }

}
