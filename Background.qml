import QtQuick 2.2

Rectangle{

    property var config

    id:root

    anchors.fill: parent
    color:settings.value("window/active_background_color","black") 
    opacity:settings.value("window/active_background_opacitiy",0.0)
    states: [
        State {
            name: "ACTIVATED"
            PropertyChanges {
                target:root
                color:settings.value("window/active_background_color","black") 
                opacity:settings.value("window/active_background_opacitiy",0.0)
            }
        },
        State {
            name: "DEACTIVATED"
            PropertyChanges {
                target:root
                color:settings.value("window/deactive_background_color","black") 
                opacity:settings.value("window/deactive_background_opacitiy",0.0)
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
