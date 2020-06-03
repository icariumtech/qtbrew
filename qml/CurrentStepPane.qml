import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import QtCharts 2.3

Item {
    Pane {
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
                anchors.leftMargin: Units.smallMargin
                text: "Current Brew Step"
                font.pixelSize: Units.headlineFontSize
                color: Material.foreground
            }
        }

        RowLayout {
            id: currentStepStats
            anchors.left: parent.left
            anchors.leftMargin: Units.largeMargin
            anchors.right: parent.right
            anchors.rightMargin: Units.largeMargin
            anchors.top: header.bottom
            height: 160 * dp
            spacing: Units.largeMargin

            StepStat {
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: "Timer"
                value: brewSession.running ? brewSession.elapsedTimeSec :
                                             "--:--"
            }

            StepStat {
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: "Setpoint"
                value: isNaN(brewSession.setpoint) ? "---" :
                    Units.toF(brewSession.setpoint).toFixed(1) + "\xB0F"
            }

            StepStat {
                Layout.fillWidth: true
                Layout.fillHeight: true
                title: "Volume"
                value: "--"
            }
        }

        ChartView {
            anchors.left: parent.left
            anchors.leftMargin: Units.smallMargin
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: Units.smallMargin
            anchors.top: currentStepStats.bottom
            antialiasing: true
            margins.bottom: 0
            margins.left: 0
            margins.right: Units.smallMargin
            margins.top: 0
            theme: ChartView.ChartThemeDark
            backgroundColor: Material.background
            legend.visible: false

            ValueAxis {
                id: tempAxis
                min: 60
                max: 220
                tickType: ValueAxis.TicksDynamic
                tickAnchor: 60
                tickInterval: 20
                labelFormat: "%.0f"
                titleText: "Temp (\xB0F)"
                labelsFont.pixelSize: Units.subheadFontSize
            }

            ValueAxis {
                id: timeAxis
                min: 0
                max: 60
                tickType: ValueAxis.TicksDynamic
                tickAnchor: 0
                tickInterval: 5
                labelFormat: "%.0f"
                titleText: "Time (min)"
                labelsFont.pixelSize: Units.subheadFontSize
            }

            LineSeries {
                id: setPointSeries
                axisX: timeAxis
                axisY: tempAxis
                color: Material.color(Material.Red)
                width: 2
            }

            LineSeries {
                id: tempSeries
                axisX: timeAxis
                axisY: tempAxis
                color: Material.color(Material.Blue)
                width: 2
            }

            Component.onCompleted: {
                tempData.registerSetpointSeries(setPointSeries)
                tempData.registerTempSeries(tempSeries)
            }
        }
    }
}
