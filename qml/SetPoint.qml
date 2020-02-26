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

    Layout.preferredHeight: (382 - 194) * dp

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

        RadialBar {
            anchors.top: parent.top
            anchors.topMargin: Units.largeMargin
            anchors.right: parent.right
            anchors.rightMargin: Units.largeMargin
            width: parent.height
            penStyle: Qt.RoundCap
            progressColor: Material.accent
            foregroundColor: "#393e46"
            dialWidth: 8
            minValue: 65
            maxValue: 154
            value: 120
//            startAngle: 90
//            spanAngle: 180
            suffixText: "\xB0F"
            textFont {
                pointSize: Units.titleFontSize
            }
            textColor: Material.foreground
        }

//        ChartView {
//            id: chart
//            title: ""
//            antialiasing: true
//            anchors.left: parent.left
//            anchors.leftMargin: -8
//            anchors.right: parent.right
//            anchors.rightMargin: -8
//            anchors.top: header.bottom
//            height: 194 * dp
//            margins.left: 0
//            margins.right: 0
//            margins.bottom: 0
//            margins.top: 0
//            legend.visible: false

//            backgroundRoundness: 0

//            LineSeries {
//                XYPoint { x: 0; y: 0 }
//                XYPoint { x: 1.1; y: 2.1 }
//                XYPoint { x: 1.9; y: 3.3 }
//            }
//        }

        Text {
            id: currentTemp
            anchors.top: header.bottom
            anchors.left: parent.left
            anchors.leftMargin: Units.largeMargin
            text: "156" + "\xB0F"
            font.pixelSize: Units.display3FontSize
            font.bold: true
            color: Material.foreground
        }
    }

}
