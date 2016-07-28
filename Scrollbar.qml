import QtQuick 2.2
import QMLTermWidget 1.0

QMLTermScrollbar {

    property var terminal_margin:settings.value("window/content_margin",1)-1
    width: settings.value("scrollbar/width",1)-terminal_margin

    Rectangle {
        id:bar
        opacity: settings.value("scrollbar/opacity",1.0)
        radius:  0.0
        anchors.fill: parent
    }

    states: [

        State {
            name: "ACTIVATED"
            PropertyChanges {
                target:bar;
                color:settings.value("scrollbar/active_color","#000")
            }
        },

        State {
            name: "DEACTIVATED"
            PropertyChanges {
                target:bar;
                color:settings.value("scrollbar/deactive_color","#fff")
            }
        }

    ]
}
