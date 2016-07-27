import QtQuick 2.2

Rectangle{

    property var config
    property var random
    property var random_colors
    property var active_color 
    property var deactive_color

    Component.onCompleted:{
        active_color=settings.value("background/active_color","black")
        deactive_color=settings.value("background/deactive_color","black")
        var random=settings.value("background/random","false")=="true"
        var random_colors=settings.value("background/random_colors","#004422,#002244,#220044,#440022,#224400,#442200") 
        if(random){
            random_colors=random_colors.split(',')
            active_color=deactive_color=random_colors[Math.floor(Math.random()*random_colors.length)]
        }
    }

    id:root

    anchors.fill: parent
    color:active_color 
    opacity:settings.value("background/active_opacitiy",0.0)
    states: [
        State {
            name: "ACTIVATED"
            PropertyChanges {
                target:root
                color:active_color
                opacity:settings.value("background/active_opacitiy",0.0)
            }
        },
        State {
            name: "DEACTIVATED"
            PropertyChanges {
                target:root
                color:deactive_color
                opacity:settings.value("background/deactive_opacitiy",0.0)
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
