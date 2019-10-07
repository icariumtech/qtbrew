import QtQuick 2.0

Item {
    signal setpointClicked(string name, int setpoint_value)

    Row {
        id: column
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 75

        Kettle {
            id: boil
            kettleName: "Boil"
            liquidColor: "red"
            liquidVolumn: 0
            onClicked: {
                setpointClicked("Boil", 0)
            }
        }

        Kettle {
            id: mash_tun
            kettleName: "Mash Tun"
            liquidColor: "burlywood"
            liquidVolumn: 0
            onClicked: {
                setpointClicked("Mash Tun", 0)
            }
        }

        Kettle {
            id: hlt
            kettleName: "HLT"
            liquidVolumn: 0
            onClicked: {
                setpointClicked("HLT", 0)
            }
        }
    }
}
