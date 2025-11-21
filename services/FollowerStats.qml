// FollowerStats.qml
pragma Singleton
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import "../utils"

// Service that provides information about the active toplevel (title, class, icon)
Singleton {
    id: root

    // Public readonly properties used by the UI
    readonly property string activeTitle: _activeTitle
    readonly property string className: _className
    readonly property string imageSource: _imageSource
    readonly property string fallBackEmoji: _fallBackEmoji
    property var screen: null
    // Internal state
    property string _activeTitle: ""
    property string _windowAddress: ""
    property string _className: ""
    property string _imageSource: ""
    property string _fallBackEmoji: "🌀"

    // Public method to force refresh
    function refresh() {
        updateActiveWindowInfo();
    }

    function updateActiveWindowInfo() {
        Hyprland.refreshToplevels();
        var activeToplevel = getActiveToplevel();
        root._activeTitle = getTitle(activeToplevel);
        root._className = getClassName(activeToplevel);
        root._windowAddress = activeToplevel ? activeToplevel.address : "";
        root._fallBackEmoji = Icons.getFallbackEmoji(root._className);
        root._imageSource = Icons.getAppIcon(root._className);
        // If class is empty the icon might load later; trigger the retry timer
        console.log("Class name is: " + root._className);
        if (root._className === "")
            retryIconLoadingTimer.running = true;

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

        return rawTitle;
    }

    function getActiveToplevel() {
        if (!Hyprland)
            return null;

        return Hyprland.activeToplevel;
    }

    Connections {
        function onActiveToplevelChanged() {
            console.log("Active toplevel changed");
            root.updateActiveWindowInfo();
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
        onTriggered: {
            updateActiveWindowInfo();
        }
    }

}
