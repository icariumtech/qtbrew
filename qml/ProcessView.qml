import QtQuick 2.0

Item {
    Row {
        id: column
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 75

        Kettle {
            id: boil
            kettleName: "Boil"
            liquidColor: "red"
            liquidVolumn: 0
        }

        Kettle {
            id: mash_tun
            kettleName: "Mash Tun"
            liquidColor: "burlywood"
            liquidVolumn: 0
        }

        Kettle {
            id: hlt
            kettleName: "HLT"
            liquidVolumn: 0
        }
    }
}
