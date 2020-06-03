pragma Singleton
import QtQuick 2.0

QtObject {
    readonly property string sansFontFamily: "Roboto"
    readonly property string serifFontFamily: "Roboto Slab"

    readonly property real captionFontSize: 12 * dp
    readonly property real bodyFontSize: 14 * dp
    readonly property real subheadFontSize: 16 * dp
    readonly property real titleFontSize: 20 * dp
    readonly property real headlineFontSize: 24 * dp
    readonly property real display1FontSize: 34 * dp
    readonly property real display2FontSize: 45 * dp
    readonly property real display3FontSize: 56 * dp
    readonly property real display4FontSize: 112 * dp

    readonly property real largeMargin: 16 * dp
    readonly property real smallMargin: 8 * dp

    function toF(c)
    {
        return c * 1.8 + 32
    }
}
