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
    // Hyprland
    readonly property var toplevels: Hyprland.toplevels
    readonly property var workspaces: Hyprland.workspaces
    readonly property var monitors: Hyprland.monitors
    readonly property HyprlandToplevel activeToplevel: getActiveToplevel()
    readonly property HyprlandWorkspace focusedWorkspace: Hyprland.focusedWorkspace
    readonly property HyprlandMonitor focusedMonitor: Hyprland.focusedMonitor
    // Internal state
    property string _activeTitle: getTitle(activeToplevel)
    property string _className: getClassName(activeToplevel)
    property string _imageSource: Icons.getAppIcon(_className)
    property string _fallBackEmoji: Icons.getFallbackEmoji(_className)

    function getActiveToplevel() {
        var activeToplevel = Hyprland.activeToplevel;
        if (!activeToplevel)
            return null;

        if (activeToplevel.wayland && activeToplevel.wayland.activated)
            return activeToplevel;

        return null;
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
            return "";

        var rawTitle = String(activeToplevel.title);
        if (rawTitle.includes("Visual Studio Code") && rawTitle.includes("●"))
            rawTitle = rawTitle.replace("●", "").trim();

        return rawTitle;
    }

    Connections {
        function onRawEvent(event) {
            const name = event.name;
            if (name === "configreloaded") {
                root.configReloaded();
                root.reloadDynamicConfs();
            } else if (["workspace", "moveworkspace", "activespecial", "focusedmon"].includes(name)) {
                Hyprland.refreshWorkspaces();
                Hyprland.refreshMonitors();
            } else if (["openwindow", "closewindow", "movewindow"].includes(name)) {
                Hyprland.refreshToplevels();
                Hyprland.refreshWorkspaces();
            } else if (name.includes("mon"))
                Hyprland.refreshMonitors();
            else if (name.includes("workspace"))
                Hyprland.refreshWorkspaces();
            else if (name.includes("window") || name.includes("group") || ["pin", "fullscreen", "changefloatingmode", "minimize"].includes(name))
                Hyprland.refreshToplevels();
        }

        target: Hyprland
    }

}
