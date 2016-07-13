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
        font.pixelSize: 18
    }

    DropShadow {
        id:shadow
        anchors.fill:text 
        samples: 17
        color: "white"
        source:text
    }

    states: [

        State {
            name: "ACTIVATED"
            PropertyChanges {target:text;color:'black';}
            PropertyChanges { target:shadow;radius:10;}
        },

        State {
            name: "DEACTIVATED"
            PropertyChanges {target:text;color:'black';}
            PropertyChanges { target:shadow; radius:3;}
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
