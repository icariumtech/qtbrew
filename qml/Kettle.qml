import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Universal 2.12
import QtQuick.Layouts 1.12

Item {
    property color liquidColor: "blue"
    property double totalVolumn : 20
    property double liquidVolumn: 0
    property string kettleName

    width: 125
    height: 250

    ColumnLayout {
        anchors.fill: parent
        spacing: 6

        Text {
            id: name
            Layout.alignment: Qt.AlignCenter
            text: qsTr(kettleName)
            font.pixelSize: 14
            color: Universal.foreground
        }

        SetPoint {
            width: parent.width
            height: 75
        }

        Rectangle {
            id: kettle
            Layout.fillHeight: true
            width: parent.width
            color: "#00000000"
            radius: 10
            border.color: Universal.foreground
            border.width: 2

            Rectangle {
                id: base_liquid_level
                visible: liquidVolumn > 0
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: kettle.border.width
                width: parent.width - (kettle.border.width * 2)
                height: 15
                radius: 7.5
                color: liquidColor
            }

            Rectangle {
                id: liquid_level
                visible: liquidVolumn > 0
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: base_liquid_level.verticalCenter
                width: parent.width - (kettle.border.width * 2)
                height: Math.max(liquidVolumn / totalVolumn * (parent.height - 20 - (base_liquid_level.height / 2)), 8)
                color: liquidColor
            }
        }
    }
}
