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

    function formatStat(value, unit) {
        const clamped = Math.min(99, Math.round(value));
        const padded = Strings.leftPad(clamped, 2, " ");
        return padded + unit;
    }

    function formatText(rawCpuUsage, rawCpuTemperature) {
        const usage = formatStat(rawCpuUsage, "%");
        const temperature = formatStat(rawCpuTemperature, "°C");
        return `${usage}|${temperature}`;
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
