import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtGraphicalEffects 1.0

Button {
    id: button
    property alias image: buttonImage.source
    checkable: true
    contentItem: Image {
        id: buttonImage
        anchors.fill: parent
        anchors.margins: 12
        fillMode: Image.PreserveAspectFit
        ColorOverlay {
            anchors.fill: parent
            source: parent
            color: Material.foreground
        }
    }
    background: Item {
    }
}
