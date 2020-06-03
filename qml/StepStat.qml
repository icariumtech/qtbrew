import QtQuick 2.0
import QtQuick.Controls.Material 2.12

Item {

    property alias title: titleText.text
    property alias value: valueText.text

    Rectangle {
        anchors.fill: parent
        color: "#393e46"
        opacity: .3
        radius: 3
    }

    Text {
        id: titleText
        anchors.top: parent.top
        anchors.topMargin: Units.largeMargin
        anchors.left: parent.left
        anchors.leftMargin: Units.smallMargin
        font.pixelSize: Units.headlineFontSize
        color: Material.foreground
    }

    Text {
        id: valueText
        anchors.left: parent.left
        anchors.leftMargin: Units.largeMargin
        anchors.right: parent.right
        anchors.rightMargin: Units.largeMargin
        anchors.bottom: parent.bottom
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignBottom
        font.bold: true
        font.pixelSize: 80 * dp
        color: Material.foreground
    }
}
