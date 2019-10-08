import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

Item {
    id: dashboard
    ColumnLayout {
        anchors.fill: parent
        Pane {
            Layout.fillWidth: true
            Layout.preferredHeight: 55
            Material.elevation: 6
            Text {
                id: currentStage
                anchors.centerIn: parent
                text: qsTr("Idle")
                font.pixelSize: 45
                color: Material.foreground
            }
        }

        Pane {
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
            Layout.fillWidth: true
            Material.elevation: 6
            Layout.preferredHeight: 55
        }
    }
}
