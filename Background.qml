import QtQuick 2.2

Rectangle{

    property var config
    property var active_color 
    property var deactive_color
    property var active_opacity:settings.value("background/active_opacitiy",0.0)
    property var deactive_opacity:settings.value("background/deactive_opacitiy",0.0)

    Component.onCompleted:{
        active_color=settings.value("background/active_color","black")
        deactive_color=settings.value("background/deactive_color","black")
        var random_generator=settings.value("background/random_color_generator","");
        //("background/random_color_generator","function fun(a,b){return (Math.random()*(b-a)+a).toString(16).substr(2,2);};'#'+fun(0,0.25)+fun(0,0.5)+fun(0,0.5);");

        if(random_generator.length>0)
            active_color=deactive_color=eval(random_generator);
    }

    id:root

    anchors.fill: parent

    opacity:active_opacity

    function change_opacity(value){
        value=value<0?0:value>1?1:value;
        active_opacity=value;
        deactive_opacity=value;
    }

    function increase_opacity(){
        change_opacity(root.opacity+0.05);
    }

    function decrease_opacity(){
        change_opacity(root.opacity-0.05);
    }

    states: [
        State {
            name: "ACTIVATED"
            PropertyChanges {
                target:root
                color:active_color
                opacity:active_opacity
            }
        },
        State {
            name: "DEACTIVATED"
            PropertyChanges {
                target:root
                color:deactive_color
                opacity:deactive_opacity
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
