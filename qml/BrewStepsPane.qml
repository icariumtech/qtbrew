import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import QtCharts 2.3

Item {
    Pane {
        id: brewSteps
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
                text: "Brew Steps"
                font.pixelSize: Units.headlineFontSize
                color: Material.foreground
            }
        }

        ListView {
            id: brewStepsList
            anchors.top: header.bottom
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Units.smallMargin
            anchors.left: parent.left
            anchors.leftMargin: Units.largeMargin
            anchors.right: parent.right
            anchors.rightMargin: Units.largeMargin
            clip: true

            topMargin: Units.largeMargin
            bottomMargin: Units.largeMargin

            header: Item {
                width: parent.width
                height: 32 * dp
                visible: brewStepsList.count != 0

                Rectangle {
                    id: startMark
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.leftMargin: ((40 * dp) / 2) - (width / 2)
                    width: 12 * dp
                    height: 12 * dp
                    radius: width / 2
                    color: brewSession.running ?
                               Material.color(Material.Green) :
                               Material.foreground
                }

                Rectangle {
                    width: 1
                    anchors.top: startMark.bottom
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: startMark.horizontalCenter
                    color: brewSession.running ?
                               Material.color(Material.Green) :
                               Material.foreground
                }

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 56 * dp
                    anchors.verticalCenter: startMark.verticalCenter

                    text: "Start";
                    color: Material.foreground;
                    font.pixelSize: Units.titleFontSize
                }
            }

            footer: Item {
                width: parent.width
                height: 32 * dp
                visible: brewStepsList.count != 0

                Rectangle {
                    width: 1
                    anchors.top: parent.top
                    anchors.bottom: endMark.top
                    anchors.horizontalCenter: endMark.horizontalCenter
                    color: brewSession.finished ?
                               Material.color(Material.Green) :
                               Material.foreground
                }

                Rectangle {
                    id: endMark
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.leftMargin: ((40 * dp) / 2) - (width / 2)
                    width: 12 * dp
                    height: 12 * dp
                    radius: width / 2
                    color: brewSession.finished ?
                               Material.color(Material.Green) :
                               Material.foreground
                }

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 56 * dp
                    anchors.verticalCenter: endMark.verticalCenter

                    text: "Finished";
                    color: Material.foreground;
                    font.pixelSize: Units.titleFontSize
                }
            }

            model: brewStepsModel

            delegate: BrewStepDelegate {}
        }

        RowLayout {
            anchors.left: parent.left
            anchors.leftMargin: Units.largeMargin
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Units.largeMargin
            width: brewStepsList.width
            Button {
                Layout.fillWidth: true
                text: "Begin"
                onClicked: {
                    brewSession.begin()
                }
            }
            Button {
                Layout.fillWidth: true
                text: "Next"
                onClicked: {
                    brewSession.nextStep()
                }
            }
        }
    }
}
