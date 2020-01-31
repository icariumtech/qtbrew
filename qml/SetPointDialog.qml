import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.VirtualKeyboard 2.4

Item {
    function editSetpoint(name, value, percent) {
        dialog.title = name + " Set Point";
        setpoint.text = ""
        setpoint.placeholderText = value;
        dialog.open();
        setpoint.focus = true;
        dialog.standardButton(Dialog.Apply).enabled = false
    }

    anchors.fill: parent
    property alias title: dialog.title
    property alias _x: dialog.x
    property alias _y: dialog.y
    property alias _width: dialog.width
    property alias _height: dialog.height
    property alias closePolicy: dialog.closePolicy
    property alias standardButtons: dialog.standardButtons
    default property alias contentData: dialog.contentData
    property alias _visible: dialog.visible
    visible: _visible

    focus: true

    Dialog {
        id: dialog
        x: parent.width / 2 - width / 2
        y: parent.height / 4 - height / 2
        width: 250
        focus: true
        modal: false
        closePolicy: Popup.CloseOnEscape

        standardButtons: Dialog.Cancel | Dialog.Apply
        contentItem: Item {
            TextField {
                id: setpoint
                anchors.left: parent.left
                anchors.right: parent.right
                inputMethodHints: Qt.ImhDigitsOnly
                validator: IntValidator {
                    bottom: 75
                    top: 212
                }
                onAccepted: {
                    if ((text > 75) && (text < 212))
                    {
                        dialog.accept()
                    }
                }
                onTextChanged: {
                    dialog.standardButton(Dialog.Apply).enabled =
                            ((text > 75) && (text <= 212))
                }
            }
        }
        onApplied: {
            dialog.accept()
        }
    }
    MouseArea {
        anchors.fill: parent
        z: 100
    }
    Rectangle {
        anchors.fill: parent
        color: "#393e46"
        opacity: dialog.opacity / 2
        z: 100
    }
}
