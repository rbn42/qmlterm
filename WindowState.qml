import QtQuick 2.2

Item{

    property var config
    property var terminal
    property var faketitle
    property var titleshadow
    property var fakeborder
    property var bordershadow


    function changestate(_active,_visibility){
        if(_visibility==4){
            state="MAXIMIZED"
        }else if(_visibility==5){
            state="MAXIMIZED" // "FULLSCREEN"
        }else if(_active){
            state="ACTICATED"
        }else{
            state="DEACTIVATED"
        }
    }

    states: [
        State {
            name: "DEACTIVATED"
            PropertyChanges {
                target:fakeborder.border;
                width:1;
                color:config.border_color_deactive
            }
            PropertyChanges { 
                target: bordershadow;
                radius:config.border_shadow_deactive;
                color:config.border_color_deactive
            }
            PropertyChanges {target:faketitle;color:'black';}
            PropertyChanges { target: titleshadow; radius:3;}
            PropertyChanges {target:terminal.anchors;topMargin:18;}
        },
        State {
            name: "ACTICATED"
            PropertyChanges {
                target:fakeborder.border;
                width:1;
                color:config.border_color_active
            }
            PropertyChanges { 
                target: bordershadow;
                radius:config.border_shadow_active;
                color:config.border_color_active
            }
            PropertyChanges {target:faketitle;color:'black';}
            PropertyChanges { target: titleshadow;radius:10;}
            PropertyChanges {target:terminal.anchors;topMargin:18;}
        },
        State {
            name: "MAXIMIZED_NOTITLE"
            PropertyChanges {target:fakeborder.border;width:0;}
            PropertyChanges {target:faketitle;color:'transparent';}
            PropertyChanges {target:terminal.anchors;topMargin:0;}
        },
        State {
            name: "MAXIMIZED"
            PropertyChanges {target:fakeborder.border;width:0;}
        }
    ]

    transitions: [
        Transition {
            from: "DEACTIVATED"
            to: "ACTICATED"
            ColorAnimation { target: fakeborder.border; 
                duration:config.animation_duration
            }
            ColorAnimation { target: bordershadow; 
                duration: config.animation_duration
            }
            ColorAnimation { target: titleshadow; 
                duration: config.animation_duration 
            }
            NumberAnimation {target:bordershadow;
                properties: "radius";
                duration:config.animation_duration 
            }
            NumberAnimation {target:titleshadow;
                properties: "radius";
                duration:config.animation_duration 
            }
// easing.type: Easing.InOutQuad }
        },
        Transition {
            from: "ACTICATED"
            to: "DEACTIVATED"
            ColorAnimation { target: fakeborder.border; 
                duration:config.animation_duration
            }
            ColorAnimation { target: bordershadow; 
                duration:config.animation_duration
            }
            ColorAnimation { target: titleshadow; 
                duration:config.animation_duration 
            }
            NumberAnimation {target:bordershadow;
                properties: "radius";duration: config.animation_duration
            }
            NumberAnimation {target:titleshadow;
                properties: "radius";duration: config.animation_duration
            }
            // easing.type: Easing.InOutQuad }
        }
    ]


}
