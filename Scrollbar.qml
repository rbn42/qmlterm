
import QtQuick 2.2
import QMLTermWidget 1.0

QMLTermScrollbar {
    width: settings.value("scrollbar/width",1)
    Rectangle {
        color:settings.value("scrollbar/color","#000")
        opacity: settings.value("scrollbar/opacity",1.0)
        radius:  0.0
        anchors.fill: parent
    }
}
