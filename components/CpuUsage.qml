import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell.Io

Item {
    id: root

    property var currentCpuStats: []
    property var previousCpuStats: []
    property var cpuUsage: null

    signal requestShowPopover()

    function parseCpuStats() {
        var fileContent = procStatsView.text();
        var lines = fileContent.split("\n");
        for (const line of lines) {
            if (!line.startsWith("cpu"))
                continue;

            const parts = line.trim().split(/\s+/);
            const [cpuId, user, nice, system, idle, iowait, irq, softirq] = parts;
            const total = user + nice + system + idle + iowait + irq + softirq;
            const busy = total - idle;
            currentCpuStats = {
                "total": total,
                "busy": busy
            };
            break; // We found what we want so stop parsing
        }
    }

    function updateCpuUsage() {
        previousCpuStats = currentCpuStats;
        const [prevTotal, prevBusy] = [previousCpuStats.total, previousCpuStats.busy];
        const [currTotal, currBusy] = [currentCpuStats.total, currentCpuStats.busy];
        console.log("Prev Total: " + prevTotal + " Prev Busy: " + prevBusy);
        console.log("Curr Total: " + currTotal + " Curr Busy: " + currBusy);
    }

    width: cpu.implicitWidth
    height: cpu.implicitHeight

    DisplayButton {
        id: cpu

        mainText: "??%|??°C"
        labelText: "🧠"
        onRequestShowPopover: {
            root.displayButtonClicked();
        }
    }

    Timer {
        id: updateTimer

        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            parseCpuStats();
            updateCpuUsage();
        }
    }

    FileView {
        id: procStatsView

        path: "/proc/stat"
        watchChanges: true
        onFileChanged: this.reload()
    }

}
