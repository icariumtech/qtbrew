import QtQuick 2.0
import QtQuick.Controls.Material 2.12

Component {
    Item {
        height: 72 * dp
        width: parent.width

        Rectangle {
            anchors.left: stepName.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 1
            color: "lightGrey"
            opacity: .1
            visible: index == 0
        }

        Rectangle {
            width: 1
            anchors.top: parent.top
            anchors.bottom: stepIcon.top
            anchors.left: parent.left
            anchors.leftMargin: ((40 * dp) / 2)
            color: active || complete ? Material.color(Material.Green) :
                            Material.foreground
        }

        Rectangle {
            id: stepIcon
            height: 40 * dp
            width: 40 * dp
            radius: height / 2
            color: Material.background
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left

            border.color: active ? Material.color(Material.Yellow) :
                                   (complete ? Material.color(Material.Green) :
                                             Material.foreground)
            border.width: 1
        }

        Rectangle {
            width: 1
            anchors.top: stepIcon.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: ((40 * dp) / 2)
            color: complete ? Material.color(Material.Green) :
                            Material.foreground

        }

        Text {
            id: stepName
            anchors.left: stepIcon.left
            anchors.leftMargin: 56 * dp
            anchors.top: stepIcon.top

            text: name;
            color: Material.foreground;
            font.pixelSize: Units.titleFontSize
        }

        Rectangle {
            anchors.left: stepName.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 1
            color: "lightGrey"
            opacity: .1
        }
    }
}
