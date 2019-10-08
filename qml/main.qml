import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.VirtualKeyboard 2.4
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

ApplicationWindow {
    id: window
    visible: true
    width: 800
    height: 480
    title: qsTr("Qt Brew")

    Material.theme: Material.Dark
    Material.accent: Material.color(Material.Yellow, Material.Shade800)

    Rectangle {
        id: splash
        anchors.fill: parent
        color: "black"
        layer.enabled: true
        Image {
            y: -40
            source: "qrc:///images/brewerycontroller.png"
        }
    }

    Item {
        id: mainPanel
        anchors.fill: parent
        opacity: 0

        NavigationPane {
            id: navigation
            width: 55
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            onSwitchPage: {
                pageStack.switchPage(idx)
            }
        }

        PageStack {
            id: pageStack
            anchors.left: navigation.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
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
                id: inputPanelTransition
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

        SetPointDialog {
            id: setpointDialog
            anchors.fill: parent
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
