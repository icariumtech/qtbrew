import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.VirtualKeyboard 2.4
import QtQuick.Controls 2.12
import QtQuick.Controls.Universal 2.12

ApplicationWindow {
    id: window
    visible: true
    width: 800
    height: 480
    title: qsTr("Qt Brew")

    Universal.theme: Universal.Dark

    Image {
        id: splash
        source: "qrc:///images/brewerycontroller.png"
    }

    Item {
        id: mainPanel
        anchors.fill: parent
        opacity: 0

        Item {
            id: sideView
            width: 200
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            Rectangle {
                id: sizeViewVDivider
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                width: 1
                color: Universal.foreground
            }

            Item {
                id: buttonPanel
                height: 75
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: sizeViewVDivider.left
            }

            Rectangle {
                id: sideViewHDivider
                anchors.top: buttonPanel.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: Universal.foreground
            }

            Item {
                id: recipeView
                anchors.left: parent.left
                anchors.right: sizeViewVDivider.left
                anchors.top: sideViewHDivider.bottom
                anchors.bottom: parent.bottom
            }
        }

        Item {
            id: statusBar
            height: 50
            anchors.left: sideView.right
            anchors.right: parent.right
            anchors.top: parent.top

            Rectangle {
                id: statusBarHDivider
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: 1
                color: Universal.foreground
            }

            Text {
                anchors.centerIn: parent
                text: qsTr("Manual")
                color: Universal.foreground
                font.pixelSize: 35
            }
        }

        ProcessView {
            id: processView
            anchors.top: statusBar.bottom
            anchors.topMargin: 6
            anchors.left: sideView.right
            anchors.right: parent.right
        }

        InputPanel {
            id: inputPanel
            z: 99
            x: 0
            y: window.height
            width: window.width

            states: State {
                name: "visible"
                when: inputPanel.active
                PropertyChanges {
                    target: inputPanel
                    y: window.height - inputPanel.height
                }
            }
            transitions: Transition {
                from: ""
                to: "visible"
                reversible: true
                ParallelAnimation {
                    NumberAnimation {
                        properties: "y"
                        duration: 250
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    }

    SequentialAnimation {
        id: startAnimation
        ParallelAnimation {
            NumberAnimation { target: splash; properties: "opacity"
                duration: 750; to: 0
            }
            NumberAnimation { target: splash; properties: "scale"
                duration: 750; to: 0.9
            }
        }
        ParallelAnimation {
            NumberAnimation { target: mainPanel; properties: "opacity"
                duration: 750; to: 1
            }
        }
        Component.onCompleted: startAnimation.start()
    }
}
