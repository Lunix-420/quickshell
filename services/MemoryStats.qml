// MemoryStats.qml
pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import "../utils"

// Provides memory usage (used memory in kB) by parsing /proc/meminfo
Singleton {
    id: root

    // Public readonly property (kB)
    readonly property real memoryUsage: _memoryUsage
    // Internal state
    property real _memoryUsage: 0

    // Parse /proc/meminfo and return used memory (MemTotal - MemAvailable) in kB
    function parseProcMeminfo() {
        var fileContent = procMeminfoView.text();
        var lines = fileContent.split("\n");
        var targets = {
            "MemTotal": null,
            "MemAvailable": null
        };
        for (var i = 0; i < lines.length; ++i) {
            var line = lines[i];
            for (var key in targets) {
                if (line.startsWith(key)) {
                    var parts = line.trim().split(/\s+/);
                    targets[key] = parseFloat(parts[1]);
                }
            }
        }
        if (targets["MemTotal"] === null || targets["MemAvailable"] === null)
            return 0;

        var usedMemory = targets["MemTotal"] - targets["MemAvailable"];
        return Bytes.fromKibiBytes(usedMemory);
    }

    // Update the internal memory usage property from the FileView
    function updateMemoryStats() {
        procMeminfoView.reload();
        _memoryUsage = parseProcMeminfo();
    }

    Component.onCompleted: updateMemoryStats()

    // Polling timer
    Timer {
        id: pollTimer

        interval: 1000
        running: true
        repeat: true
        onTriggered: updateMemoryStats()
    }

    // FileView to read /proc/meminfo
    FileView {
        id: procMeminfoView

        path: "/proc/meminfo"
    }

}
