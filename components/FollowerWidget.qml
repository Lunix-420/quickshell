// FollowerWidget.qml
import "../config"
import "../services"
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

Item {
    id: root

    required property var screen

    signal requestShowPopover()

    implicitWidth: button.implicitWidth + 16
    implicitHeight: 55
    Component.onCompleted: {
        FollowerStats.screen = screen;
        FollowerStats.refresh();
    }
    onScreenChanged: {
        FollowerStats.screen = screen;
    }

    RectangularShadow {
        visible: FollowerStats.activeTitle !== ""
        anchors.fill: button
        blur: 5
        spread: 1
        radius: 20
        color: Colors.shadow
        cached: true
    }

    Button {
        id: button

        visible: FollowerStats.activeTitle !== ""
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

            color: Colors.surface0
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
                color: Colors.text
                leftPadding: 4
                topPadding: 4
            }

            IconImage {
                id: toplevelIcon

                visible: FollowerStats.imageSource !== ""
                source: FollowerStats.imageSource
                implicitWidth: 24
                implicitHeight: 32
                asynchronous: true
                mipmap: true
            }

            Text {
                id: mainLabel

                text: FollowerStats.activeTitle
                font.family: "Comic Sans MS"
                font.pixelSize: 16
                color: Colors.text
                topPadding: 4
                leftPadding: 3
                rightPadding: 5
            }

        }

    }

}
