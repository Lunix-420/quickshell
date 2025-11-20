// CpuStats.qml
pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

// Provides information aboute the CPU usage and temperature
Singleton {
    id: root

    // Global CPU usage and temperature state
    readonly property real cpuUsage: _cpuUsage
    readonly property real cpuTemperature: _cpuTemperature
    property var _previousProcStats: parseProcStats()
    property real _cpuUsage: 0
    property real _cpuTemperature: 0

    // Parses `/proc/stat` and returns an object with total and busy CPU times
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

    // Calculates CPU usage based on delta between last and current readings
    function calculateCpuUsage(previous, current) {
        const busyDelta = current.busy - previous.busy;
        const totalDelta = current.total - previous.total;
        if (totalDelta === 0)
            return 0;

        const usage = (busyDelta / totalDelta) * 100;
        return usage;
    }

    // Updates CPU usage and temperature properties
    function updateCpuStats() {
        procStatsView.reload();
        const procStats = parseProcStats();
        _cpuUsage = calculateCpuUsage(_previousProcStats, procStats);
        _previousProcStats = procStats;
        sensorsProcess.running = true;
    }

    // Parses the output `sensors` and returns temperature values
    function parseSensorsOutput(output) {
        const lines = text.split("\n");
        for (const line of lines) {
            if (!line.includes("Tdie"))
                continue;

            const values = line.match(/[+-]?\d+\.?\d*/g);
            const floats = values.map((v) => {
                return parseFloat(v, 10);
            });
            const [current, high] = floats;
        }
    }

    // Timer to periodically update CPU stats
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            updateCpuStats();
            sensorsProcess.running = true;
        }
    }

    // FileView to read `/proc/stat` for CPU usage
    FileView {
        id: procStatsView

        path: "/proc/stat"
    }

    // Process to run `sensors` command for CPU temperature
    Process {
        id: sensorsProcess

        command: ["sensors"]
        environment: ({
            "LANG": "C.UTF-8",
            "LC_ALL": "C.UTF-8"
        })

        stdout: StdioCollector {
            onStreamFinished: {
                const [current, high] = parseSensorsOutput(text);
                _cpuTemperature = current;
            }
        }

    }

}
