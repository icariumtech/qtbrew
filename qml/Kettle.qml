import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

Item {
    id: kettle
    signal clicked()

    property color liquidColor: "blue"
    property double totalVolumn : 20
    property double liquidVolumn: 0
    property string kettleName

    width: 200
    height: 400

    layer.enabled: true

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Text {
            id: name
            Layout.alignment: Qt.AlignCenter
            text: qsTr(kettleName)
            font.pixelSize: 22
            color: Material.foreground
        }

        SetPoint {
            width: parent.width
            height: 100
            onClicked: {
                kettle.clicked()
            }
        }

        Rectangle {
            id: kettleFrame
            Layout.fillHeight: true
            width: parent.width
            color: "#00000000"
            radius: 10
            border.color: Material.foreground
            border.width: 2

            Rectangle {
                id: base_liquid_level
                visible: liquidVolumn > 0
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: kettleFrame.border.width
                width: parent.width - (kettleFrame.border.width * 2)
                height: 15
                radius: 7.5
                color: liquidColor
            }

            Rectangle {
                id: liquid_level
                visible: liquidVolumn > 0
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: base_liquid_level.verticalCenter
                width: parent.width - (kettleFrame.border.width * 2)
                height: Math.max(liquidVolumn / totalVolumn * (parent.height - 20 - (base_liquid_level.height / 2)), 8)
                color: liquidColor
            }
        }
    }
}
