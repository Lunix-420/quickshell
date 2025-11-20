import "../config"
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell.Io

// Top bar display widget base component
Item {
    id: root

    // Exposed properties
    property string mainText: "-"
    property string labelText: "-"

    // Emits a request to show a popover when the widget is clicked
    signal requestShowPopover()

    // Dimensions
    implicitWidth: button.implicitWidth + 16
    implicitHeight: 55

    // Shadow effect
    RectangularShadow {
        anchors.fill: button
        blur: 5
        spread: 1
        radius: 20
        color: Colors.shadow
        cached: true
    }

    // Main display element
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
            bottomMargin: 10.5
        }

        background: Rectangle {
            id: backgroundRect

            color: Colors.surface0
            radius: 20
        }

        contentItem: Row {
            anchors.centerIn: parent
            spacing: 4

            // Icon on the left side of the widget
            Text {
                id: emojiLabel

                text: labelText
                font.family: "ComicShannsMono Nerd Font Mono"
                font.pixelSize: 20
                color: Colors.text
                leftPadding: 5
                topPadding: 5
            }

            // Main text on the right side of the widget
            Text {
                id: mainLabel

                text: mainText
                font.family: "ComicShannsMono Nerd Font Mono"
                font.pixelSize: 16
                color: Colors.text
                topPadding: 7
            }

        }

    }

}
