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
            id: processPane
            opacity: 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Units.largeMargin

            BrewSteps {
                Layout.minimumWidth: hltsetpoint.width
                Layout.fillHeight: true
            }

            Pane {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Material.elevation: 6
            }
        }

        RowLayout {
            id: setPoints
            Layout.fillWidth: true
            spacing: Units.largeMargin
            opacity: 0
            SetPoint {
                id: hltsetpoint
                Layout.fillWidth: true
                title: "Hot Liquor Tank"
                temp: hlt.temp
            }
            SetPoint {
                Layout.fillWidth: true
                title: "Mash Lauter Tun"
                temp: mashLower.temp
            }
            SetPoint {
                Layout.fillWidth: true
                title: "Boil Kettle"
                temp: boil.temp
            }
        }

        RowLayout {
            id: pumps
            Layout.fillWidth: true
            spacing: Units.largeMargin
            opacity: 0
            PumpPanel {
                Layout.fillWidth: true
                title: "Water Pump"
                relayEnabled: waterPump.enabled
                onClicked: {
                    waterPump.enabled = !waterPump.enabled
                }
            }
            Item {
                Layout.fillWidth: true
            }
            PumpPanel {
                Layout.fillWidth: true
                title: "Wort Pump"
                relayEnabled: wortPump.enabled
                onClicked: {
                    wortPump.enabled = !wortPump.enabled
                }
            }
        }
    }

    SequentialAnimation {
        id: startAnimation
        NumberAnimation { target: processPane; properties: "opacity"
            duration: 500; to: 1; easing.type: Easing.OutBounce
        }
        NumberAnimation { target: setPoints; properties: "opacity"
            duration: 500; to: 1; easing.type: Easing.OutBounce
        }
        NumberAnimation { target: pumps; properties: "opacity"
            duration: 500; to: 1; easing.type: Easing.OutBounce
        }
    }
}
