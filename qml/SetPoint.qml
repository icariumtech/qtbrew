import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Item {
    id: setpoint
    signal clicked()

    property color mainColor: Material.foreground
    property var error: false

    layer.enabled: true

    Rectangle {
        id: button
        anchors.fill: parent
        anchors.margins: 5
        color: Material.background
        radius: 10
        border.color: mainColor
        border.width: 1

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

    SequentialAnimation on mainColor {
        id: errorAnimation
        ColorAnimation {
            from: mainColor
            to: "red"
            duration: 1000
        }
        ColorAnimation {
            from: "red"
            to: mainColor
            duration: 1000
        }
        loops: Animation.Infinite
        running: error
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
