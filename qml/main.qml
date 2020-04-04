import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.VirtualKeyboard 2.4
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

ApplicationWindow {
    id: window
    visible: true
    width: 1280
    height: 800
    title: qsTr("Qt Brew")
    color: "#393e46"

    Material.theme: Material.Dark
    Material.accent: "#f96d00"
    Material.background: "#222831"
    Material.foreground: "#e7e5e5"

    Rectangle {
        id: splash
        anchors.fill: parent
        color: "#393e46"
        layer.enabled: true
        Image {
            y: -40
            source: "qrc:///images/brewerycontroller.png"
        }
    }

    Item {
        id: mainPanel
        anchors.fill: parent

        NavigationPane {
            id: navigation
            opacity: 0
            width: 100 * dp
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
        NumberAnimation { target: splash; properties: "opacity"
            duration: 1000; to: 0
        }
        NumberAnimation { target: navigation; properties: "opacity"
            duration: 1000; to: 1; easing.type: Easing.OutBounce
        }
        Component.onCompleted: startAnimation.start()
        onStopped: {
            pageStack.show()
        }
    }
}
