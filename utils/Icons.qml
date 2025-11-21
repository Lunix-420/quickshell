// Icons.qml
pragma Singleton
import Quickshell

Singleton {
    function getFallbackEmoji(className) {
        if (!className)
            return "🌀";

        if (className.toLowerCase().includes("steam"))
            return "🎮";

        return "🌀";
    }

    function getAppIcon(className) {
        if (!className || className === "")
            return "";

        var lookup = DesktopEntries.heuristicLookup(className);
        if (!lookup)
            return "";

        var icon = lookup.icon;
        if (!icon)
            return "";

        return Quickshell.iconPath(icon);
    }

}
