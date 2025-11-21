// FollowerStats.qml
pragma Singleton
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

// Service that provides information about the active toplevel (title, class, icon)
Singleton {
    id: root

    // Public readonly properties used by the UI
    readonly property string activeTitle: _activeTitle
    readonly property string className: _className
    readonly property string imageSource: _imageSource
    readonly property string fallBackEmoji: _fallBackEmoji
    property var screen: null
    readonly property int maxCharacters: (screen && screen.name === "DP-1") ? 140 : 55
    // Internal state
    property string _activeTitle: ""
    property string _className: ""
    property string _imageSource: ""
    property string _fallBackEmoji: "🌀"

    // Public method to force refresh
    function refresh() {
        updateActiveWindowInfo();
    }

    function updateActiveWindowInfo() {
        var activeToplevel = getActiveToplevel();
        root._activeTitle = getTitle(activeToplevel);
        root._className = getClassName(activeToplevel);
        root._fallBackEmoji = getFallbackEmoji();
        root._imageSource = getAppIcon(root._className);
        // If class is empty the icon might load later; trigger the retry timer
        if (root._className === "")
            retryIconLoadingTimer.running = true;

    }

    function getFallbackEmoji() {
        if (!root._className)
            return "🌀";

        if (root._className.toLowerCase().includes("steam"))
            return "🎮";

        return "🌀";
    }

    function getClassName(activeToplevel) {
        if (!activeToplevel)
            return "";

        if (activeToplevel.lastIpcObject && activeToplevel.lastIpcObject.class)
            return activeToplevel.lastIpcObject.class;

        if (activeToplevel.wayland && activeToplevel.wayland.appId)
            return activeToplevel.wayland.appId;

        if (activeToplevel["class"])
            return activeToplevel["class"];

        console.error("No class name found for active toplevel, returning empty string");
        return "";
    }

    function getTitle(activeToplevel) {
        if (!activeToplevel || !activeToplevel.title)
            return "Unnamed Window";

        var rawTitle = String(activeToplevel.title);
        if (rawTitle.includes("Visual Studio Code") && rawTitle.includes("●"))
            rawTitle = rawTitle.replace("●", "").trim();

        var maxChars = Math.max(0, root.maxCharacters);
        if (rawTitle.length <= maxChars)
            return rawTitle;

        var truncationLength = Math.max(0, maxChars - 3);
        return rawTitle.slice(0, truncationLength) + "...";
    }

    function getAppIcon() {
        if (!root._className || root._className === "")
            return "";

        var lookup = DesktopEntries.heuristicLookup(root._className);
        if (!lookup)
            return "";

        var icon = lookup.icon;
        if (!icon)
            return "";

        return Quickshell.iconPath(icon);
    }

    function getActiveToplevel() {
        if (!Hyprland)
            return null;

        return Hyprland.activeToplevel;
    }

    Component.onCompleted: {
        // Ensure initial values are populated
        if (Hyprland)
            Hyprland.refreshToplevels();

        updateActiveWindowInfo();
    }

    Connections {
        function onActiveToplevelChanged() {
            updateActiveWindowInfo();
        }

        function onRawEvent(event) {
            if (event.name === "closewindow")
                _activeTitle = "";

        }

        target: Hyprland
    }

    Timer {
        id: retryIconLoadingTimer

        interval: 100
        running: false
        repeat: true
        onTriggered: {
            updateActiveWindowInfo();
            // stop if we have a valid icon or class
            if (root._imageSource || root._className !== "")
                retryIconLoadingTimer.running = false;

        }
    }

}
