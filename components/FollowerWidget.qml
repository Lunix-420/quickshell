import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Widgets

Item {
    id: root

    property string activeTitle: ""
    property string className: ""
    property string imageSource: ""
    property string fallBackEmoji: "🌀"
    property int maxCharacters: root.screen.name === "DP-1" ? 140 : 57
    required property var screen

    signal requestShowPopover()

    function updateActiveWindowInfo() {
        const activeToplevel = getActiveToplevel();
        if (!activeToplevel) {
            root.visible = false;
            return ;
        }
        root.visible = true;
        root.activeTitle = getTitle(activeToplevel);
        root.className = getClassName(activeToplevel);
        root.fallBackEmoji = getFallbackEmoji();
        imageSource = getAppIcon(root.className);
        // Retry loading icon if not found
        // This is needed because the class may load later then the toplevel change event
        if (className === "")
            retryIconLoadingTimer.running = true;

    }

    function getFallbackEmoji() {
        if (root.className.toLowerCase().includes("steam"))
            return "🎮";

        return "🌀";
    }

    function getClassName(activeToplevel) {
        // Prefer the IPC-provided class if available
        if (activeToplevel.lastIpcObject && activeToplevel.lastIpcObject.class)
            return activeToplevel.lastIpcObject.class;

        // Fallback to Wayland appId
        if (activeToplevel.wayland && activeToplevel.wayland.appId)
            return activeToplevel.wayland.appId;

        // Fallback to XWayland class
        if (activeToplevel["class"])
            return activeToplevel["class"];

        // Houston, we have a problem
        console.error("No class name found for active toplevel, returning empty string");
        return "";
    }

    function getTitle(activeToplevel) {
        if (!activeToplevel || !activeToplevel.title)
            return "Unnamed Window";

        const rawTitle = String(activeToplevel.title);
        const maxChars = Math.max(0, root.maxCharacters);
        if (rawTitle.length <= maxChars)
            return rawTitle;

        const truncationLength = Math.max(0, maxChars - 3);
        return rawTitle.slice(0, truncationLength) + "...";
    }

    function getAppIcon() {
        if (!root.className || root.className === "")
            return "";

        const lookup = DesktopEntries.heuristicLookup(root.className);
        if (!lookup)
            return "";

        const icon = lookup.icon;
        if (!icon)
            return "";

        return Quickshell.iconPath(icon);
    }

    function getActiveToplevel() {
        const activeToplevel = Hyprland.activeToplevel;
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

    Timer {
        id: sanityTimer

        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            root.updateActiveWindowInfo();
        }
    }

    Timer {
        id: retryIconLoadingTimer

        interval: 100
        running: false
        onTriggered: {
            root.updateActiveWindowInfo();
        }
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
                implicitHeight: 32
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
                leftPadding: 3
                rightPadding: 5
            }

        }

    }

}
