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
    Universal.background: Universal.Steel

    Item {
        id: recipeView
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 200
        Rectangle {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            width: 1
            color: Universal.foreground
        }
    }

    ProcessView {
        id: processView
        anchors.top: parent.top
        anchors.topMargin: 6
        anchors.left: recipeView.right
        anchors.right: parent.right
    }

    Item {
        anchors.top: processView.bottom
        anchors.left: recipeView.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
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
