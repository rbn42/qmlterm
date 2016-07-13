import QtQuick 2.2

Rectangle{

    property var config

    anchors.fill: parent
    color: config.background_color
    opacity:config.background_opacitiy

}
