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

    function formatSpeed(bytesPerSecond) {
        const [speed, unit] = Bytes.normalize(bytesPerSecond, "kB", 100);
        const speedRounded = Strings.roundToLength(speed, 4);
        const speedString = Strings.leftPad(speedRounded, 4, " ");
        const unitString = Strings.leftPad(unit, 2, " ");
        return speedString + " " + unitString;
    }

    width: download.implicitWidth * 2
    height: download.implicitHeight

    DisplayButton {
        id: upload

        mainText: formatSpeed(NetworkStats.uploadSpeed)
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

        mainText: formatSpeed(NetworkStats.downloadSpeed)
        labelText: "🔻"
        onRequestShowPopover: {
            root.requestShowPopover();
        }

        anchors {
            left: parent.left
        }

    }

}
