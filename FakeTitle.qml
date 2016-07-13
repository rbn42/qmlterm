import QtQuick 2.2
import QtGraphicalEffects 1.0

Item{

    property var config

    property alias shadow:shadow
    property alias text:text

    anchors.fill: parent


    Text {
        id:text

        horizontalAlignment:Text.AlignHCenter
        anchors.fill: parent
        color: "black"
        font.pixelSize: settings.value("title/font_size",18)

        font.family:settings.value("title/font","monospace")
    }

    DropShadow {
        id:shadow

        anchors.fill:text 
        samples: 17
        source:text

        spread:settings.value("title/shadow_spread",0.6)
    }

    states: [

        State {
            name: "ACTIVATED"
            PropertyChanges {target:text;color:'black';}
            PropertyChanges { 
                target:shadow;
                radius:10;
                color: settings.value("title/shadow_color_active",'white')
            }
        },

        State {
            name: "DEACTIVATED"
            PropertyChanges {target:text;color:'black';}
            PropertyChanges { 
                target:shadow;
                radius:3;
                color: settings.value("title/shadow_color_deactive",'white')
            
            }
        },

        State {
            name: "MAXIMIZED_NOTITLE"
            PropertyChanges {target:text;color:'transparent';}
        }

    ]

    transitions: [

        Transition {
            from: "DEACTIVATED"
            to: "ACTIVATED"
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
            ColorAnimation { target:shadow; 
                duration:config.animation_duration 
            }
            NumberAnimation {target:shadow;
                properties: "radius";duration: config.animation_duration
            }
        }

    ]
}
