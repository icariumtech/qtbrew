import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Universal 2.12

Item {
//    Rectangle {
//        anchors.fill: parent
//        color: "#00000000"
//        radius: 10
//        border.color: Universal.foreground
//        border.width: 1
//        Rectangle {
//            anchors.left: parent.left
//            anchors.right: parent.horizontalCenter
//            anchors.rightMargin: 5
//            anchors.top: parent.top
//            anchors.bottom: parent.bottom
//            color: Universal.foreground
//            radius: 10
//        }

//        Rectangle {
//            height: parent.height * .75
//            width: parent.height * .75
//            rotation: 45
//            anchors.horizontalCenter: parent.horizontalCenter
//            anchors.verticalCenter: parent.verticalCenter
//            anchors.horizontalCenterOffset: -10
//            color: Universal.foreground
//        }

//        Text {
//            id: currentTemp
//            anchors.left: parent.left
//            anchors.right: parent.horizontalCenter
//            anchors.verticalCenter: parent.verticalCenter
//            color: Universal.background
//            horizontalAlignment: Qt.AlignHCenter
//            font.pointSize: 14
//            text: "57" + "\xB0 F"
//        }

//        Text {
//            id: setPoint
//            anchors.left: parent.horizontalCenter
//            anchors.right: parent.right
//            anchors.verticalCenter: parent.verticalCenter
//            color: Universal.foreground
//            horizontalAlignment: Qt.AlignHCenter
//            font.pointSize: 14
//            text: "76"  + "\xB0 F"
//        }
//    }

    Rectangle {
        anchors.fill: parent
        color: "#00000000"
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
            text: "57" + "\xB0 F"
        }

        Text {
            id: setPoint
            anchors.top: parent.verticalCenter
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            color: Universal.foreground
            verticalAlignment: Qt.AlignVCenter
            font.pixelSize: parent.height / 2 - 10
            text: "76"  + "\xB0 F"
        }
    }

    MouseArea {
        anchors.fill: parent
        onPressed: {

        }
    }
}
