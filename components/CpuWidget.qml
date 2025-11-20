import "../config"
import "../services"
import "../utils"
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell.Io

Item {
    id: root

    signal requestShowPopover()

    function formatText(rawCpuUsage, rawCpuTemperature) {
        const cpuUsage = Math.min(99, Math.round(rawCpuUsage));
        const cpuUsageString = Strings.leftPad(cpuUsage, 2, " ") + "%";
        const cpuTemperature = Math.min(99, Math.round(rawCpuTemperature));
        const cpuTemperatureString = Strings.leftPad(cpuTemperature, 2, " ") + "°C";
        return `${cpuUsageString}|${cpuTemperatureString}`;
    }

    width: widget.implicitWidth
    height: widget.implicitHeight

    DisplayButton {
        id: widget

        mainText: formatText(CpuStats.cpuUsage, CpuStats.cpuTemperature)
        labelText: "🖥️"
        onRequestShowPopover: {
            root.requestShowPopover();
        }
    }

}
