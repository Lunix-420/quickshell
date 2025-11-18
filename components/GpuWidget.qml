//nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader | tr -dc '[:digit:]'

import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell.Io

Item {
    id: root

    property var gpuUsage: null
    property var gpuTemperature: null

    signal requestShowPopover()

    function updateMainText() {
        const usageInt = Math.round(gpuUsage);
        const usageString = (usageInt < 10 ? " " : "") + usageInt + "%";
        const temperatureInt = Math.round(gpuTemperature);
        const temperatureString = (temperatureInt < 10 ? " " : "") + temperatureInt + "°C";
        gpu.mainText = `${usageString}|${temperatureString}`;
    }

    width: gpu.implicitWidth
    height: gpu.implicitHeight

    DisplayButton {
        id: gpu

        mainText: "5%|38°C"
        labelText: "🖥️"
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
            usageProcess.running = true;
            temperatureProcess.running = true;
        }
    }

    Process {
        id: usageProcess

        command: ["sh", "-c", "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader | tr -dc '[:digit:]'"]
        environment: ({
            "LANG": "C.UTF-8",
            "LC_ALL": "C.UTF-8"
        })

        stdout: StdioCollector {
            onStreamFinished: {
                gpuUsage = parseFloat(text);
                updateMainText();
            }
        }

    }

    Process {
        id: temperatureProcess

        command: ["sh", "-c", "nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader | tr -dc '[:digit:]'"]
        environment: ({
            "LANG": "C.UTF-8",
            "LC_ALL": "C.UTF-8"
        })

        stdout: StdioCollector {
            onStreamFinished: {
                gpuTemperature = parseFloat(text);
                updateMainText();
            }
        }

    }

}
