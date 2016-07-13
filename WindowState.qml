import QtQuick 2.2

Item{

    property var config
    property var terminal
    property var faketitle
    property var fakeborder
    property var background

    function changestate(_active,_visibility){
        if(_visibility==4){
            state="MAXIMIZED"
        }else if(_visibility==5){
            state="MAXIMIZED" // "FULLSCREEN"
        }else if(_active){
            state="ACTIVATED"
        }else{
            state="DEACTIVATED"
        }
    }

    states: [

        State {
            name: "ACTIVATED"
            PropertyChanges {
                target:background;
                state:"ACTIVATED"
            }
            PropertyChanges {
                target:fakeborder.border.border;
                width:1;
                color:settings.value("border/active_color","")
            }
            PropertyChanges { 
                target: fakeborder.shadow;
                radius:settings.value("border/active_shadow",0);
                color:settings.value("border/active_color","")
            }
            PropertyChanges {target:faketitle.text;color:'black';}
            PropertyChanges { target: faketitle.shadow;radius:10;}
            PropertyChanges {target:terminal.anchors;topMargin:18;}
        },

        State {
            name: "DEACTIVATED"
            PropertyChanges {
                target:background;
                state:"DEACTIVATED"
            }
            PropertyChanges {
                target:fakeborder.border.border;
                width:1;
                color:settings.value("border/deactive_color","")
            }
            PropertyChanges { 
                target: fakeborder.shadow;
                radius:settings.value("border/deactive_shadow",0);
                color:settings.value("border/deactive_color","")
            }
            PropertyChanges {target:faketitle.text;color:'black';}
            PropertyChanges { target: faketitle.shadow; radius:3;}
            PropertyChanges {target:terminal.anchors;topMargin:18;}
        },

        State {
            name: "MAXIMIZED_NOTITLE"
            PropertyChanges {target:fakeborder.border.border;width:0;}
            PropertyChanges {target:faketitle.text;color:'transparent';}
            PropertyChanges {target:terminal.anchors;topMargin:0;}
        },

        State {
            name: "MAXIMIZED"
            PropertyChanges {
                target:background;
                state:"DEACTIVATED"
            }
            PropertyChanges {target:fakeborder.border.border;width:0;}
        }
    ]

    transitions: [
        Transition {
            from: "DEACTIVATED"
            to: "ACTIVATED"
            ColorAnimation { target: fakeborder.border.border; 
                duration:config.animation_duration
            }
            ColorAnimation { target: fakeborder.shadow; 
                duration: config.animation_duration
            }
            ColorAnimation { target: faketitle.shadow; 
                duration: config.animation_duration 
            }
            NumberAnimation {target:fakeborder.shadow;
                properties: "radius";
                duration:config.animation_duration 
            }
            NumberAnimation {target:faketitle.shadow;
                properties: "radius";
                duration:config.animation_duration 
            }
// easing.type: Easing.InOutQuad }
        },
        Transition {
            from: "ACTIVATED"
            to: "DEACTIVATED"
            ColorAnimation { target: fakeborder.border.border; 
                duration:config.animation_duration
            }
            ColorAnimation { target: fakeborder.shadow; 
                duration:config.animation_duration
            }
            ColorAnimation { target: faketitle.shadow; 
                duration:config.animation_duration 
            }
            NumberAnimation {target:fakeborder.shadow;
                properties: "radius";duration: config.animation_duration
            }
            NumberAnimation {target:faketitle.shadow;
                properties: "radius";duration: config.animation_duration
            }
            // easing.type: Easing.InOutQuad }
        }
    ]


}
