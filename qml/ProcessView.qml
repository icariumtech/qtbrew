import QtQuick 2.0

Item {
    signal setpointClicked(string name, int setpoint_value)

    Canvas {
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.strokeStyle = "#555555";
            ctx.strokeWidth = 1;
            var center_x = width / 2;
            var center_y = height / 2;
            ctx.beginPath();
            var idx = 0;
            for (idx = 0; center_x + idx <= width; idx += 25)
            {
                ctx.moveTo(center_x + idx, 0);
                ctx.lineTo(center_x + idx, height);
                ctx.stroke();

                ctx.moveTo(center_x - idx, 0);
                ctx.lineTo(center_x - idx, height);
                ctx.stroke();
            }

            for (idx = 0; center_y + idx <= height; idx += 25)
            {
                ctx.moveTo(0, center_y + idx);
                ctx.lineTo(width, center_y + idx);
                ctx.stroke();

                ctx.moveTo(0, center_y - idx);
                ctx.lineTo(width, center_y - idx);
                ctx.stroke();
            }

            ctx.closePath();
        }
    }

    Row {
        id: column
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: width / 5

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
