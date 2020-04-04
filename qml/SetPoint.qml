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

    Layout.preferredHeight: 250 * dp

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
            anchors.right: parent.right
            anchors.rightMargin: Units.largeMargin
            anchors.top: header.bottom
            anchors.topMargin: Units.largeMargin
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Units.largeMargin
            visible: !isNaN(temp)
            text: (temp * 1.8 + 32).toFixed(1) + "\xB0F"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignBottom
            font.bold: true
            font.pixelSize: 80
            color: Material.foreground
        }

        Item {
            id: warning
            anchors.centerIn: currentTemp
            visible: isNaN(temp)

            Image {
                id: warningImage
                anchors.centerIn: parent
                source: "qrc:/images/warning.png"
                fillMode: Image.PreserveAspectFit
                height: 80
            }

            Text {
                id: leftArrows
                anchors.right: warningImage.left
                anchors.verticalCenter: warningImage.verticalCenter
                text: "<<<"
                font.pixelSize: 50
                font.bold: true
                color: "red"
            }

            Text {
                id: rightArrows
                anchors.left: warningImage.right
                anchors.verticalCenter: warningImage.verticalCenter
                text: ">>>"
                font.pixelSize: 50
                font.bold: true
                color: "red"
            }

            Timer {
                id: textTimer
                interval: 500
                repeat: true
                running: isNaN(temp)
                onTriggered: {
                    if (leftArrows.text == "<<<")
                    {
                        leftArrows.text = ""
                        rightArrows.text = ""
                    }
                    else
                    {
                        leftArrows.text = leftArrows.text + "<"
                        rightArrows.text = rightArrows.text + ">"
                    }
                }
            }
        }
    }
}
