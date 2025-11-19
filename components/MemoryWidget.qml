import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell.Io

Item {
    id: root

    property var memoryUsage: null

    signal requestShowPopover()

    function parseProcMeminfo() {
        var fileContent = procMeminfoView.text();
        var lines = fileContent.split("\n");
        var targets = {
            "MemTotal": null,
            "MemFree": null,
            "MemAvailable": null
        };
        for (const line of lines) {
            for (const key in targets) {
                if (line.startsWith(key)) {
                    const parts = line.trim().split(/\s+/);
                    targets[key] = parseFloat(parts[1]);
                }
            }
        }
        var usedMemory = targets["MemTotal"] - targets["MemAvailable"];
        return usedMemory;
    }

    function updateMainText() {
        const usageInGb = (memoryUsage / 1024 ** 2).toFixed(1);
        const paddedUsage = usageInGb < 10 ? " " + usageInGb : usageInGb;
        memory.mainText = (paddedUsage) + "GB";
    }

    width: memory.implicitWidth
    height: memory.implicitHeight

    DisplayButton {
        id: memory

        mainText: "--.-GB"
        labelText: "💾"
        onRequestShowPopover: {
            root.requestShowPopover();
        }
    }

    Timer {
        id: updateTimer

        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            procMeminfoView.reload();
            memoryUsage = parseProcMeminfo();
            updateMainText();
        }
    }

    FileView {
        id: procMeminfoView

        path: "/proc/meminfo"
    }

}
