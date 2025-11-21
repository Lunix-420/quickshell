// GpuWidget.qml
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

    function formatText(rawGpuUsage, rawGpuTemp) {
        const usageCropped = Math.min(99, Math.round(rawGpuUsage));
        const usageString = Strings.leftPad(usageCropped, 2, " ") + "%";
        const tempCropped = Math.min(99, Math.round(rawGpuTemp));
        const temperatureString = Strings.leftPad(tempCropped, 2, " ") + "°C";
        return `${usageString}|${temperatureString}`;
    }

    width: gpu.implicitWidth
    height: gpu.implicitHeight

    DisplayButton {
        id: gpu

        mainText: formatText(GpuStats.gpuUsage, GpuStats.gpuTemperature)
        labelText: "🕹️"
        onRequestShowPopover: {
            root.requestShowPopover();
        }
    }

}
