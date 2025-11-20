// NetworkStats.qml
pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

// Provides network usage (bytes/sec) by parsing /proc/net/dev
Singleton {
    id: root

    // Name of network interface to monitor (matches previous widget default)
    property string interfaceName: "enp34s0"
    // Public readonly properties (bytes per second)
    readonly property real downloadSpeed: _downloadSpeed
    readonly property real uploadSpeed: _uploadSpeed
    // Internal state
    property real _downloadSpeed: 0
    property real _uploadSpeed: 0
    property var _previousProcNetDev: parseProcNetDev()

    // Parse /proc/net/dev and return rx/tx bytes for the configured interface
    function parseProcNetDev() {
        var fileContent = procNetDevView.text();
        var lines = fileContent.split("\n");
        var download = null;
        var upload = null;
        for (const line of lines) {
            if (line.indexOf(interfaceName + ":") !== -1) {
                const parts = line.trim().split(/\s+/);
                // parts[1] is receive bytes, parts[9] is transmit bytes
                download = parseFloat(parts[1]);
                upload = parseFloat(parts[9]);
                break;
            }
        }
        return {
            "download": download,
            "upload": upload
        };
    }

    function calculateNetworkSpeeds(previous, current) {
        // Guard: if previous or current values are missing, return zeros
        if (!previous || previous.download === null || previous.upload === null)
            return {
            "download": 0,
            "upload": 0
        };

        if (!current || current.download === null || current.upload === null)
            return {
            "download": 0,
            "upload": 0
        };

        const downloadDelta = current.download - previous.download;
        const uploadDelta = current.upload - previous.upload;
        // Speeds in bytes per second (since timer is 1s)
        return {
            "download": downloadDelta,
            "upload": uploadDelta
        };
    }

    // Polling timer: reload /proc/net/dev, compute deltas, update public properties
    Timer {
        id: pollTimer

        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            procNetDevView.reload();
            var current = parseProcNetDev();
            var rawSpeeds = calculateNetworkSpeeds(_previousProcNetDev, current);
            _downloadSpeed = rawSpeeds.download;
            _uploadSpeed = rawSpeeds.upload;
            _previousProcNetDev = current;
        }
    }

    // FileView to read /proc/net/dev
    FileView {
        id: procNetDevView

        path: "/proc/net/dev"
    }

}
