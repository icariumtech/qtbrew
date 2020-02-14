import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

Item {
    id: dashboard

    function show() {
        startAnimation.start()
    }

    ColumnLayout {
        anchors.fill: parent

        Item {
            id: setPoints
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            opacity: 0
            RowLayout {
                anchors.fill: parent
                Pane {
                    Material.elevation: 6
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    padding: 0
                    Button {
                        flat: true
                        anchors.fill: parent
                    }
                }
                Pane {
                    Material.elevation: 6
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Button {
                        flat: true
                        anchors.fill: parent
                    }
                }
                Pane {
                    Material.elevation: 6
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Button {
                        flat: true
                        anchors.fill: parent
                    }
                }
                Pane {
                    Material.elevation: 6
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Button {
                        flat: true
                        anchors.fill: parent
                    }
                }
            }
        }

        Pane {
            id: processPane
            opacity: 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            Material.elevation: 6
            ProcessView {
                id: processView
                anchors.fill: parent
                onSetpointClicked: {
                    setpointDialog.editSetpoint(name, setpoint_value, false)
                }
            }
        }

        Pane {
            id: timerPane
            opacity: 0
            Layout.fillWidth: true
            Material.elevation: 6
            Layout.preferredHeight: 55
        }
    }

    SequentialAnimation {
        id: startAnimation
        NumberAnimation { target: setPoints; properties: "opacity"
            duration: 500; to: 1; easing.type: Easing.OutBounce
        }
        NumberAnimation { target: processPane; properties: "opacity"
            duration: 500; to: 1; easing.type: Easing.OutBounce
        }
        NumberAnimation { target: timerPane; properties: "opacity"
            duration: 500; to: 1; easing.type: Easing.OutBounce
        }
    }
}
