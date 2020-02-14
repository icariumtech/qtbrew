import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtGraphicalEffects 1.0

Item {
    id: setpoint
    signal clicked()

    property color mainColor: Material.foreground
    property var error: false

    layer.enabled: error
    layer.effect: Glow {
        id: errorGlow
        samples: 0
        color: "red"
        transparentBorder: true

        SequentialAnimation on samples {
            id: errorAnimation
            NumberAnimation {
                from: 0
                to: 25
                duration: 500
            }
            NumberAnimation {
                from: 25
                to: 0
                duration: 500
            }
            loops: Animation.Infinite
            running: error
        }
    }

    Rectangle {
        id: button
        anchors.fill: parent
        anchors.margins: 5
        color: Material.background
        radius: 10
        border.color: mainColor
        border.width: 2

        Rectangle {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.bottom: parent.verticalCenter
            color: mainColor
            radius: 10
        }

        Rectangle {
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.bottom: parent.verticalCenter
            color: mainColor
        }

        Text {
            id: currentTemp
            anchors.top: parent.top
            anchors.bottom: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            color: Material.background
            verticalAlignment: Qt.AlignVCenter
            font.pixelSize: parent.height / 2 - 10
            text: "--" + "\xB0 F"
        }

        Text {
            id: setPoint
            anchors.top: parent.verticalCenter
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            color: mainColor
            verticalAlignment: Qt.AlignVCenter
            font.pixelSize: parent.height / 2 - 10
            text: "--"  + "\xB0 F"
        }
    }

    MouseArea {
        anchors.fill: parent
        onPressed: {
            mainColor = Material.accent
        }
        onReleased: {
            mainColor = Material.foreground
        }
        onClicked: {
            setpoint.clicked()
        }
    }
}
