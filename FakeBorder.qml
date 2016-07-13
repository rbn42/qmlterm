import QtQuick 2.2
import QtGraphicalEffects 1.0

Item{

    property var config

    property alias border:border
    property alias shadow:shadow

    anchors.fill: parent

    Rectangle{
        id:border
        anchors.fill: parent
        color:'transparent'
        visible:config.enable_border
    }

    DropShadow {
        id:shadow
        anchors.fill: border
       // radius: 5
        samples: 17
        color: "black"
        source: border
        visible:config.enable_border_shadow
        spread:config.shadow_spread 
    }

    states: [

        State {
            name: "ACTIVATED"
            PropertyChanges {
                target:border.border;
                width:1;
                color:config.border_color_active
            }
            PropertyChanges { 
                target: shadow;
                radius:config.border_shadow_active;
                color:config.border_color_active
            }
        },

        State {
            name: "DEACTIVATED"
            PropertyChanges {
                target:border.border;
                width:1;
                color:config.border_color_deactive
            }
            PropertyChanges { 
                target: shadow;
                radius:config.border_shadow_deactive;
                color:config.border_color_deactive
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
