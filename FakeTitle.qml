import QtQuick 2.2
import QtGraphicalEffects 1.0

Item{
    property alias shadow:shadow
    property alias text:text

    anchors.fill: parent

    Text {
        id:text
        horizontalAlignment:Text.AlignHCenter
        anchors.fill: parent
        color: "black"
        font.pixelSize: 18
    }

    DropShadow {
        id:shadow
        anchors.fill:text 
        samples: 17
        color: "white"
        source:text
    }

}
