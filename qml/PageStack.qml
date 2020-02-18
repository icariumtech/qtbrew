import QtQuick 2.0
import QtQuick.Controls 2.12
import "."

Item {
    id: pageStack

    function show() {
        dashBoard.show()
    }

    function switchPage(idx) {
        swipView.setCurrentIndex(idx)
    }

    SwipeView {
        id: swipView
        anchors.fill: parent
        orientation: Qt.Vertical
        interactive: false

        Item {
            width: pageStack.width
            height: pageStack.height
            DashboardPane {
                id: dashBoard
                anchors.fill: parent
                anchors.margins: Units.largeMargin
            }
        }

        Item {
            width: pageStack.width
            height: pageStack.height
            RecipePane {
                anchors.fill: parent
                anchors.margins: Units.largeMargin
            }
        }

        Item {
            width: pageStack.width
            height: pageStack.height
            RecipePane {
                anchors.fill: parent
                anchors.margins: Units.largeMargin
            }
        }

        Item {
            width: pageStack.width
            height: pageStack.height
            RecipePane {
                anchors.fill: parent
                anchors.margins: Units.largeMargin
            }
        }
    }
}
