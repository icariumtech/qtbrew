import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

Item {
    id: pumpPanel
    signal clicked()

    property alias title: titleText.text
    property bool relayEnabled: false

    Layout.preferredHeight: 125 * dp

    Pane {
        id: setpoint
        anchors.fill: parent
        Material.elevation: 6
        padding: 0

        Item {
            id: header
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 72 * dp

            Text {
                id: titleText
                anchors.top: parent.top
                anchors.topMargin: Units.largeMargin
                anchors.left: parent.left
                anchors.leftMargin: Units.largeMargin
                font.pointSize: Units.subheadFontSize
                color: Material.foreground
            }
        }

        Button {
            anchors.right: parent.right
            anchors.rightMargin: Units.largeMargin
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width / 3
            text: relayEnabled ? "ON" : "OFF"
            highlighted: relayEnabled
            Material.accent: Material.color(Material.Green, Material.Shade700)
            font.pixelSize: Units.headlineFontSize
            onClicked: {
                pumpPanel.clicked()
            }
        }
    }
}
