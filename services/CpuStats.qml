import Quickshell
pragma Singleton

Singleton {
    // Global CPU usage and temperature state
    readonly property real cpuUsage: _cpuUsage
    readonly property real cpuTemperature: _cpuTemperature

    property var _previousProcStats: parseProcStats()
    property real _cpuUsage: 0
    property real _cpuTemperature: 0

    function parseProcStats() {
        var fileContent = procStatsView.text();
        var lines = fileContent.split("\n");
        for (const line of lines) {
            if (!line.startsWith("cpu"))
                continue;
            const parts = line.trim().split(/\s+/).map((x) => Number(x));
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

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            procStatsView.reload();
            const procStats = parseProcStats();
            _cpuUsage = calculateCpuUsage(_previousProcStats, procStats);
            _previousProcStats = procStats;
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
                    const floats = values.map((v) => parseFloat(v, 10));
                    const [current, high] = floats;
                    _cpuTemperature = current;
                }
            }
        }
    }
}
}
