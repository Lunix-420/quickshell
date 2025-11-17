import Quickshell.Io

import QtQuick
import QtQuick.Effects
import QtQuick.Controls


Item {
    id: root

    // Exposed properties for reuse
    property string scriptPath: ""
    property string mainText: "-"
    property string labelText: "-"

    implicitWidth: powerBtn.implicitWidth+16
    implicitHeight: 55

    RectangularShadow {
        anchors.fill: powerBtn
        blur: 5
        spread: 1
        radius: 20
        color: powerBtn.hovered ? btnColor :'#000000'
        cached: true
    }

    Button {
    id: powerBtn
    anchors{
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
        color: powerBtn.hovered ? btnColor :"#363A4F"
        radius: 20             
    }

    contentItem: Row {
        anchors.centerIn: parent
        spacing: 4

        Text {
            id: emojiLabel
            text: labelText         
            font.family: "ComicShannsMono Nerd Font Mono"
            font.pixelSize: 22
            color: "#cad3f5"
            leftPadding: 5
            topPadding: 4
        }

        Text {
            id: mainLabel
            text: mainText
            font.family: "ComicShannsMono Nerd Font Mono"
            font.pixelSize: 18       
            color: "#cad3f5"
            topPadding: 5
        }
    }

    onClicked: {
        if (root.scriptPath !== "") {
            scriptRunner.exec({
                command: ["sh", "-c", root.scriptPath]
            })
        }
    }
  }
}
