import QtQuick 2.0
import CustomControls 1.0
import QtCharts 2.3
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

Item {
    signal clicked()

    property alias title: titleText.text
    property var temp: 0.0

    Layout.preferredHeight: 220 * dp

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
                font.pixelSize: Units.titleFontSize
                color: Material.foreground
            }
        }

        Text {
            id: currentTemp
            anchors.left: parent.left
            anchors.leftMargin: Units.largeMargin
            anchors.top: header.bottom
            text: (isNaN(temp) ? "--" : (temp * 1.8 + 32).toFixed(1)) + "\xB0F"
            font.pixelSize: Units.display3FontSize
            font.bold: true
            color: Material.foreground
        }
//        Item {
//            anchors.right: parent.right
//            anchors.rightMargin: Units.largeMargin
//            anchors.top: header.bottom

//            Text {
//                id: setpointHeader
//                anchors.right: parent.right
//                anchors.top: parent.top
//                text: "Setpoint"
//                color: Material.foreground
//                font.pixelSize: Units.subheadFontSize
//            }
//            Text {
//                anchors.right: parent.right
//                anchors.top: setpointHeader.bottom
//                text: "212" + "\xB0F"
//                color: Material.foreground
//                font.pixelSize: Units.titleFontSize
//            }
//        }

//        RadialBar {
//            id: setpointProgress
//            anchors.top: header.bottom
//            anchors.bottom: parent.bottom
//            anchors.left: parent.left
//            anchors.leftMargin: Units.largeMargin
//            penStyle: Qt.RoundCap
//            progressColor: Material.accent
//            foregroundColor: "#393e46"
//            dialWidth: 8
//            value: 0
//            suffixText: "%"
//            textFont {
//                pointSize: Units.subheadFontSize
//            }
//            textColor: Material.foreground
//        }

//        RoundButton {
//            id: editButton
//            anchors.right: parent.right
//            anchors.bottom: parent.bottom
//            highlighted: true
//        }
    }
}
