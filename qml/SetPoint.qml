import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Universal 2.12
import QtGraphicalEffects 1.12

Item {
    layer.enabled: true

    Rectangle {
        id: glowBox
        visible: false
        anchors.fill: parent
        anchors.margins: 10
        radius: 10
        color: Universal.foreground
        layer.enabled: true
        layer.effect: Glow {
            samples: 40
            color: Universal.foreground
            transparentBorder: true
        }
    }

    Rectangle {
        id: button
        anchors.fill: parent
        anchors.margins: 10
        color: Universal.background
        radius: 10
        border.color: Universal.foreground
        border.width: 1

        Rectangle {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.bottom: parent.verticalCenter
            color: Universal.foreground
            radius: 10
        }

        Rectangle {
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.bottom: parent.verticalCenter
            color: Universal.foreground
        }

        Text {
            id: currentTemp
            anchors.top: parent.top
            anchors.bottom: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: Universal.background
            verticalAlignment: Qt.AlignVCenter
            font.pixelSize: parent.height / 2 - 10
            text: "--" + "\xB0 F"
        }

        Text {
            id: setPoint
            anchors.top: parent.verticalCenter
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            color: Universal.foreground
            verticalAlignment: Qt.AlignVCenter
            font.pixelSize: parent.height / 2 - 10
            text: "--"  + "\xB0 F"
        }
    }

    MouseArea {
        anchors.fill: parent
        onPressed: {
            glowBox.visible = true
        }
        onReleased: {
            glowBox.visible = false
        }
    }
}
