import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell.Io

Item {
    id: root

    property var previousProcStats: parseProcStats()
    property var cpuUsage: null
    property var cpuTemperature: null

    signal requestShowPopover()

    function parseProcStats() {
        var fileContent = procStatsView.text();
        var lines = fileContent.split("\n");
        for (const line of lines) {
            if (!line.startsWith("cpu"))
                continue;

            const parts = line.trim().split(/\s+/).map((x) => {
                return Number(x);
            });
            const [cpuId, user, nice, system, idle, iowait, irq, softirq] = parts;
            const total = user + nice + system + idle + iowait + irq + softirq;
            const busy = total - idle;
            return {
                "total": total,
                "busy": busy
            };
        }
    }

    function calculateCpuUsage(previous, current) {
        const busyDelta = current.busy - previous.busy;
        const totalDelta = current.total - previous.total;
        if (totalDelta === 0)
            return 0;

        const usage = (busyDelta / totalDelta) * 100;
        return usage;
    }

    function updateMainText() {
        const usageInt = Math.round(cpuUsage);
        const usageString = (usageInt < 10 ? " " : "") + usageInt + "%";
        const temperatureInt = Math.round(cpuTemperature);
        const temperatureString = (temperatureInt < 10 ? " " : "") + temperatureInt + "°C";
        cpu.mainText = `${usageString}|${temperatureString}`;
    }

    width: cpu.implicitWidth
    height: cpu.implicitHeight

    DisplayButton {
        id: cpu

        mainText: "--%|--°C"
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
            procStatsView.reload();
            const procStats = parseProcStats();
            cpuUsage = calculateCpuUsage(previousProcStats, procStats);
            previousProcStats = procStats;
            updateMainText();
            sensorsProcess.running = true;
        }
    }

    FileView {
        id: procStatsView

        path: "/proc/stat"
    }

    Process {
        id: sensorsProcess

        command: ["sensors"]
        environment: ({
            "LANG": "C.UTF-8",
            "LC_ALL": "C.UTF-8"
        })

        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.split("\n");
                for (const line of lines) {
                    if (!line.includes("Tdie"))
                        continue;

                    const values = line.match(/[+-]?\d+\.?\d*/g);
                    const floats = values.map((v) => {
                        return parseFloat(v, 10);
                    });
                    const [current, high] = floats;
                    cpuTemperature = current;
                    updateMainText();
                }
            }
        }

    }

}
