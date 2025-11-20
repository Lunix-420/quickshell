import "../config"
import "../services"
import "../utils"
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell.Io

// A top bar widget that displays CPU usage and temperature
Item {
    id: root

    // Emits a request to show a popover when the widget is clicked
    signal requestShowPopover()

    // Formats the CPU usage and temperature into a display string
    function formatText(rawCpuUsage, rawCpuTemperature) {
        const cpuUsage = Math.min(99, Math.round(rawCpuUsage));
        const cpuUsageString = String.leftPadString(cpuUsage, 2, " ") + "%";
        const cpuTemperature = Math.min(99, Math.round(rawCpuTemperature));
        const cpuTemperatureString = String.leftPadString(cpuTemperature, 2, " ") + "°C";
        return `${cpuUsageString}|${cpuTemperatureString}`;
    }

    // Dimensions
    width: widget.implicitWidth
    height: widget.implicitHeight

    // Main display element
    DisplayButton {
        id: widget

        mainText: formatText(CpuStats.cpuUsage, CpuStats.cpuTemperature)
        labelText: "🖥️"
        onRequestShowPopover: {
            root.requestShowPopover();
        }
    }

}
