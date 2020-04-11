import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

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

            Button {
                anchors.right: parent.right
                anchors.rightMargin: Units.largeMargin
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width / 3
                text: "Begin"
                Material.accent: Material.color(Material.Green, Material.Shade700)
                highlighted: true
            }
        }

        Rectangle {
            id: split
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: Material.foreground
            anchors.top: header.bottom
        }

        ListView {
            id: brewStepsList
            anchors.top: split.bottom
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: Units.smallMargin
            anchors.right: parent.right
            anchors.rightMargin: Units.largeMargin

            topMargin: Units.largeMargin
            bottomMargin: Units.largeMargin

            header: Item {
                width: parent.width
                height: 24 * dp

                Rectangle {
                    id: startMark
                    anchors.left: parent.left
                    anchors.leftMargin: Units.smallMargin +
                                        ((40 * dp) / 2) - (width / 2)
                    width: 12 * dp
                    height: 12 * dp
                    radius: width / 2
                    color: Material.foreground
                }

                Rectangle {
                    width: 1
                    anchors.top: startMark.bottom
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: startMark.horizontalCenter
                }
            }

            clip: true

            model: ListModel {
                ListElement {
                    name: "Heat Strike Water"
                    volume: 5
                    setpoint: 165
                }
                ListElement {
                    name: "Mash"
                    volume: 5
                    setpoint: 165
                }
                ListElement {
                    name: "Sparge"
                    volume: 5
                    setpoint: 165
                }
                ListElement {
                    name: "Boil"
                    volume: 5
                    setpoint: 165
                }
                ListElement {
                    name: "Chill"
                    volume: 5
                    setpoint: 165
                }
            }

            delegate: Component {
                Item {
                    height: 88 * dp
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
                        anchors.horizontalCenter: stepIcon.horizontalCenter
                        color: Material.foreground
                    }

                    Rectangle {
                        width: 1
                        anchors.top: stepIcon.bottom
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: stepIcon.horizontalCenter
                        color: Material.foreground
                        visible: index != brewStepsList.count - 1

                    }

                    Rectangle {
                        id: stepIcon
                        height: 40 * dp
                        width: 40 * dp
                        radius: height / 2
                        color: Material.background
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: Units.smallMargin

                        border.color: Material.foreground
                        border.width: 1
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
        }
    }
}
