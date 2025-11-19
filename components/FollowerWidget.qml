import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Widgets

Item {
    // Force no icon so fallback emoji shows

    id: root

    property string activeTitle: ""
    property string className: ""
    property string imageSource: ""
    property int maxCharacters: 60
    property string fallBackEmoji: "🌀"

    signal requestShowPopover()

    function updateActiveWindowInfo() {
        const activeToplevel = getActiveToplevel();
        root.activeTitle = getTitle(activeToplevel);
        root.className = getClassName(activeToplevel);
        imageSource = getAppIcon(root.className);
        console.log("===========================================")
        console.log("Active Title: " + root.activeTitle)
        console.log("Class Name: " + root.className)
        console.log("Image Source: " + imageSource)
    }

    function getClassName(activeToplevel) {
        const ipcClass = activeToplevel?.lastIpcObject?.class ?? "no ipc object";
        if (ipcClass !== "no ipc object") {
            return ipcClass;
        }
        // Todo: find a class name via other means if no ipc object is available
    }

    function getTitle(activeToplevel) {
        if (!activeToplevel || !activeToplevel.title) {
            return "Unnamed Window";
        }

        const rawTitle = String(activeToplevel.title);
        const maxChars = Math.max(0, root.maxCharacters);
        if (rawTitle.length <= maxChars) {
            return rawTitle;
        }

        const truncationLength = Math.max(0, maxChars - 3);
        return rawTitle.slice(0, truncationLength) + "...";
    }

    function getAppIcon(name: string, fallback: string): string {
        const icon = DesktopEntries.heuristicLookup(name)?.icon;
        if (fallback !== "undefined")
            return Quickshell.iconPath(icon, fallback);
        return Quickshell.iconPath(icon);
    }

    function getActiveToplevel() {
        const activeToplevel = Hyprland.activeToplevel;
        console.error("No active toplevel found");
        return activeToplevel;
    }

    implicitWidth: button.implicitWidth + 16
    implicitHeight: 55
    Component.onCompleted: root.updateActiveWindowInfo()

    Connections {
        function onActiveToplevelChanged() {
            root.updateActiveWindowInfo();
        }

        target: Hyprland
    }

    RectangularShadow {
        anchors.fill: button
        blur: 5
        spread: 1
        radius: 20
        color: '#000000'
        cached: true
    }

    Button {
        id: button

        onClicked: {
            requestShowPopover();
        }

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            topMargin: 8.5
            rightMargin: 4
            leftMargin: 4
            bottomMargin: 11
        }

        background: Rectangle {
            id: backgroundRect

            color: "#363A4F"
            radius: 20
        }

        contentItem: Row {
            anchors.centerIn: parent
            spacing: 4
            leftPadding: 5

            Text {
                id: fallbackEmoji

                visible: imageSource === ""   
                text: root.fallBackEmoji
                font.family: "ComicShannsMono Nerd Font Mono"
                font.pixelSize: 22
                color: "#cad3f5"
                leftPadding: 4
                topPadding: 4
            }

            IconImage {
                id: toplevelIcon

                visible: imageSource !== ""
                source: imageSource
                implicitWidth: 24
                implicitHeight: 29
                asynchronous: true
                mipmap: true
            }

            Text {
                id: mainLabel

                text: root.activeTitle
                font.family: "Comic Sans MS"
                font.pixelSize: 18
                color: "#cad3f5"
                topPadding: 3
                leftPadding: 5
                rightPadding: 5
            }

        }

    }

}
