import QtQuick 2.2
import QtGraphicalEffects 1.0

Item{

    property alias border:border
    property alias shadow:shadow

    anchors.fill: parent

    Rectangle{
        id:border
        anchors.fill: parent
        //anchors.topMargin:config.frame_border-1
        //anchors.rightMargin:config.frame_border-1
        //anchors.leftMargin:config.frame_border-1
        //anchors.bottomMargin:config.frame_border-1
        border.color: "black"
        color:'transparent'
    }

    DropShadow {
        id:shadow
        anchors.fill: border
       // radius: 5
        samples: 17
        color: "black"
        source: border
    }

}
