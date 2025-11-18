import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell.Io

Item {
    id: root

    property string interfaceName: "enp34s0"
    property var previousProcNetDev: parseProcNetDev()
    property var downloadSpeed: null
    property var uploadSpeed: null

    signal requestShowPopover()

    function updateMainText() {
        // Download
        var downlaodUnitText = downloadSpeed.unit;
        var downloadAmount = downloadSpeed.speed;
        var downloadRounded = roundBytes(downloadAmount);
        var downloadPadded = padBytes(downloadAmount);
        // Upload
        var uploadUnitText = uploadSpeed.unit;
        var uploadAmount = uploadSpeed.speed;
        var uploadRounded = roundBytes(uploadAmount);
        var uploadPadded = padBytes(uploadAmount);
        // Output
        download.mainText = downloadRounded + " " + downlaodUnitText;
        upload.mainText = uploadRounded + " " + uploadUnitText;
    }

    function roundBytes(bytes) {
        var result = bytes;
        if (bytes >= 10)
            result = bytes.toFixed(1);
        else
            result = bytes.toFixed(2);
        return result;
    }

    function padBytes(bytes) {
        var result = bytes;
        if (bytes < 10)
            result = "  " + bytes.toFixed(1);
        else if (bytes < 100)
            result = " " + bytes.toFixed(1);
        return result;
    }

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
        const downloadDelta = current.download - previous.download;
        const uploadDelta = current.upload - previous.upload;
        // Speeds in bytes per second
        return {
            "download": downloadDelta,
            "upload": uploadDelta
        };
    }

    // Converts speed from bytes to the best unit (KB/s, MB/s, etc.)
    function formatSpeed(bytesPerSecond) {
        const units = ["kiB/s", "MiB/s", "GiB/s", "TiB/s"];
        let speed = bytesPerSecond / 1024;
        let unitIndex = 0;
        while (speed >= 100 && unitIndex < units.length - 1) {
            speed /= 1024;
            unitIndex++;
        }
        return {
            "speed": speed,
            "unit": units[unitIndex]
        };
    }

    width: download.implicitWidth * 2
    height: download.implicitHeight

    DisplayButton {
        id: upload

        mainText: "---- kiB/s"
        labelText: "🔺"
        onRequestShowPopover: {
            root.requestShowPopover();
        }

        anchors {
            right: parent.right
        }

    }

    DisplayButton {
        id: download

        mainText: "---- kiB/s"
        labelText: "🔻"
        onRequestShowPopover: {
            root.requestShowPopover();
        }

        anchors {
            left: parent.left
        }

    }

    Timer {
        id: updateTimer

        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            procNetDevView.reload();
            var procNetDev = parseProcNetDev();
            var rawSpeeds = calculateNetworkSpeeds(previousProcNetDev, procNetDev);
            downloadSpeed = formatSpeed(rawSpeeds.download);
            uploadSpeed = formatSpeed(rawSpeeds.upload);
            previousProcNetDev = procNetDev;
            updateMainText();
        }
    }

    FileView {
        id: procNetDevView

        path: "/proc/net/dev"
    }

}
