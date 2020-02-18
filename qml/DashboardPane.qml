import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import "."

Item {
    id: dashboard

    function show() {
        startAnimation.start()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: Units.largeMargin

        RowLayout {
            id: setPoints
            Layout.fillWidth: true
            spacing: Units.largeMargin
            opacity: 0
            SetPoint {
                Layout.fillWidth: true
                title: "Hot Liquor Tank"
            }
            SetPoint {
                Layout.fillWidth: true
                title: "Mash Lauter Tun"
            }
            SetPoint {
                Layout.fillWidth: true
                title: "Boil Kettle"
            }
        }

        Pane {
            id: processPane
            opacity: 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            Material.elevation: 6
//            ProcessView {
//                id: processView
//                anchors.fill: parent
//                onSetpointClicked: {
//                    setpointDialog.editSetpoint(name, setpoint_value, false)
//                }
//            }
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
