import QtQuick 2.2

Rectangle{

    property var config

    id:root

    anchors.fill: parent
    color: config.background_color
    opacity:config.background_opacitiy
    states: [
        State {
            name: "ACTIVATED"
            PropertyChanges {
                target:root
                color: config.background_color
                opacity:config.background_opacitiy
            }
        },
        State {
            name: "DEACTIVATED"
            PropertyChanges {
                target:root
                color: config.background_color
                opacity:config.background_opacitiy
            }
        }
    ]

    transitions: [

        Transition {
            from: "DEACTIVATED"
            to: "ACTIVATED"
            ColorAnimation {
                duration:config.animation_duration
            }
            NumberAnimation {
                properties: "opacity";
                duration:config.animation_duration
            }
        },

        Transition {
            from: "ACTIVATED"
            to: "DEACTIVATED"
            ColorAnimation {
                duration:config.animation_duration
            }
            NumberAnimation {
                properties: "opacity";
                duration:config.animation_duration
            }
        }

    ]
}
