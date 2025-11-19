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

    property string activeTitle: "No Active Window"
    property string activeIconSource: ""
    property int maxCharacters: 60
    property string fallBackEmoji: "🌀"

    signal requestShowPopover()

    function updateActiveWindowInfo() {
        const activeToplevel = Hyprland.activeToplevel;
        if (!activeToplevel) {
            root.activeTitle = "No Active Window";
            root.activeIconSource = "";
            return ;
        }
        const clampedTitle = activeToplevel.title.length > root.maxCharacters ? activeToplevel.title.slice(0, root.maxCharacters - 3) + "..." : activeToplevel.title;
        root.activeTitle = clampedTitle ?? "Unnamed Window";
        const iconPath = root.resolveIconPath(activeToplevel);
        root.activeIconSource = iconPath;
    }

    function resolveIconPath(toplevel) {
        if (!toplevel)
            return "";

        // Use wayland appId if available, otherwise fallback to XWayland class
        var appId = "";
        if (toplevel && toplevel.wayland && toplevel.wayland.appId)
            appId = toplevel.wayland.appId;
        else if (toplevel && toplevel["class"])
            appId = toplevel["class"];
        if (appId === "")
            root.fallBackEmoji = "❓";

        appId = appId.toLowerCase();
        // If this is a Steam game and we can't resolve the icon, fallback to emoji
        if (appId.startsWith("steam_app_")) {
            root.fallBackEmoji = "🕹️";
            return "";
        }
        // Normal lookup
        let directIcon = Quickshell.iconPath(appId);
        if (directIcon && directIcon !== "")
            return directIcon;

        // Symbolic fallback
        let symbolicIcon = Quickshell.iconPath(`${appId}-symbolic`);
        if (symbolicIcon && symbolicIcon !== "")
            return symbolicIcon;

        // Nothing found → fallback emoji will display automatically
        root.fallBackEmoji = "🌀";
        return "";
    }

    implicitWidth: button.implicitWidth + 16
    implicitHeight: 55
    Component.onCompleted: root.updateActiveWindowInfo()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.updateActiveWindowInfo()
    }

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

                visible: root.activeIconSource === ""
                text: root.fallBackEmoji
                font.family: "ComicShannsMono Nerd Font Mono"
                font.pixelSize: 22
                color: "#cad3f5"
                leftPadding: 4
                topPadding: 4
            }

            IconImage {
                id: toplevelIcon

                visible: root.activeIconSource !== ""
                source: root.activeIconSource
                implicitWidth: 24
                implicitHeight: 30
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
