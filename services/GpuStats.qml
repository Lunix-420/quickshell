// GpuStats.qml
pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

// Provides GPU usage and temperature using nvidia-smi
Singleton {
    id: root

    // Public readonly properties
    readonly property real gpuUsage: _gpuUsage
    readonly property real gpuTemperature: _gpuTemperature
    // Internal state
    property real _gpuUsage: 0
    property real _gpuTemperature: 0

    // Polling timer
    Timer {
        id: pollTimer

        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            usageProcess.running = true;
            temperatureProcess.running = true;
        }
    }

    // Process to query GPU usage via nvidia-smi
    Process {
        id: usageProcess

        command: ["sh", "-c", "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader | tr -dc '[:digit:]'"]
        environment: ({
            "LANG": "C.UTF-8",
            "LC_ALL": "C.UTF-8"
        })

        stdout: StdioCollector {
            onStreamFinished: {
                var v = parseFloat(text);
                if (!isNaN(v))
                    _gpuUsage = v;

            }
        }

    }

    // Process to query GPU temperature via nvidia-smi
    Process {
        id: temperatureProcess

        command: ["sh", "-c", "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader | tr -dc '[:digit:]'"]
        environment: ({
            "LANG": "C.UTF-8",
            "LC_ALL": "C.UTF-8"
        })

        stdout: StdioCollector {
            onStreamFinished: {
                var v = parseFloat(text);
                if (!isNaN(v))
                    _gpuTemperature = v;

            }
        }

    }

}
