import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12

Pane {
    id: navigation

    signal switchPage(int idx);

    Material.elevation: 6
    padding: 0

    Rectangle {
        id: selection
        color: Material.accent
        width: parent.width
        height: parent.width
        y: dashboard.y

        Rectangle {
            color: Material.foreground
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 2
        }

        Behavior on y {
            NumberAnimation {
                duration: 200
            }
        }
    }

    ButtonGroup {
        id: navigationGroup

        onClicked: {
            selection.y = button.y
        }
    }

    ColumnLayout {
        anchors.fill: parent
        NavButton {
            id: dashboard
            Layout.fillWidth: true
            Layout.preferredHeight: navigation.width
            image: "qrc:///images/dashboard.png"
            checked: true
            ButtonGroup.group: navigationGroup
            onCheckedChanged: {
                if (checked)
                {
                    switchPage(0)
                }
            }
        }

        NavButton {
            id: recipebook
            Layout.fillWidth: true
            Layout.preferredHeight: navigation.width
            image: "qrc:///images/recipebook.png"
            ButtonGroup.group: navigationGroup
            onCheckedChanged: {
                if (checked)
                {
                    switchPage(1)
                }
            }
        }

        NavButton {
            id: settings
            Layout.fillWidth: true
            Layout.preferredHeight: navigation.width
            image: "qrc:///images/settings.png"
            ButtonGroup.group: navigationGroup
            onCheckedChanged: {
                if (checked)
                {
                    switchPage(2)
                }
            }
        }

        NavButton {
            id: info
            Layout.fillWidth: true
            Layout.preferredHeight: navigation.width
            image: "qrc:///images/information.png"
            ButtonGroup.group: navigationGroup
            onCheckedChanged: {
                if (checked)
                {
                    switchPage(3)
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
