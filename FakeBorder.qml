import QtQuick 2.2
import QtGraphicalEffects 1.0

Item{

    property var config

    property var active_color:settings.value("border/active_color","#8ff")
    property var deactive_color:settings.value("border/deactive_color","#555")
    property var border_width:settings.value("border/width",1)

    property alias border:border
    property alias shadow:shadow

    anchors.fill: parent

    Rectangle{
        id:border
        anchors.fill: parent
        color:'transparent'
        visible:"true"==settings.value("border/enable","true")
    }

    DropShadow {
        id:shadow
        anchors.fill: border
       // radius: 5
        samples: 17
        color: "black"
        source: border

        visible:"true"==settings.value("border/shadow","false")
        spread:settings.value("border/shadow_spread",0.6)
    }

    states: [

        State {
            name: "ACTIVATED"
            PropertyChanges {
                target:border.border;
                width:border_width;
                color:active_color
            }
            PropertyChanges { 
                target: shadow;
                radius:settings.value("border/active_shadow",5);
                color:active_color
            }
        },

        State {
            name: "DEACTIVATED"
            PropertyChanges {
                target:border.border;
                width:border_width;
                color:deactive_color
            }
            PropertyChanges { 
                target: shadow;
                radius:settings.value("border/deactive_shadow",1);
                color:deactive_color
            }
        },

        State {
            name: "MAXIMIZED"
            PropertyChanges {target:border.border;width:0;}
        }

    ]

    transitions: [

        Transition {
            from: "DEACTIVATED"
            to: "ACTIVATED"
            ColorAnimation { target: border.border; 
                duration:config.animation_duration
            }
            ColorAnimation { target: shadow; 
                duration: config.animation_duration
            }
            NumberAnimation {target:shadow;
                properties: "radius";
                duration:config.animation_duration 
            }
        },

        Transition {
            from: "ACTIVATED"
            to: "DEACTIVATED"
            ColorAnimation { target: border.border; 
                duration:config.animation_duration
            }
            ColorAnimation { target: shadow; 
                duration:config.animation_duration
            }
            NumberAnimation {target:shadow;
                properties: "radius";duration: config.animation_duration
            }
        }

    ]
}
