import QtQuick 2.0
import QtQuick.Controls 2.12

Item {
    id: pageStack

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
                anchors.fill: parent
                anchors.margins: 10
            }
        }

        Item {
            width: pageStack.width
            height: pageStack.height
            RecipePane {
                anchors.fill: parent
                anchors.margins: 10
            }
        }

        Item {
            width: pageStack.width
            height: pageStack.height
            RecipePane {
                anchors.fill: parent
                anchors.margins: 10
            }
        }

        Item {
            width: pageStack.width
            height: pageStack.height
            RecipePane {
                anchors.fill: parent
                anchors.margins: 10
            }
        }
    }
}
