import QtQuick 2.2
import QtGraphicalEffects 1.0

Item{

    property var config
    property var terminal
    property var enable:"true"==settings.value("title/enable","true")
    property var title_size_:parseInt(settings.value("title/size",18))
    property var title_size:enable?title_size_:0

    property alias shadow:shadow
    property alias text:text

    anchors.fill: parent


    Text {
        id:text

        horizontalAlignment:Text.AlignHCenter
        anchors.fill: parent
        color: "black"

        visible:enable
        font.pixelSize:title_size 
        font.family:settings.value("title/font","ubuntu mono,monospace")
    }

    DropShadow {
        id:shadow

        anchors.fill:text 
        samples: 17
        source:text

        visible:"true"==settings.value("title/shadow","true")
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
            PropertyChanges {target:terminal.anchors;topMargin:title_size;}
        },

        State {
            name: "DEACTIVATED"
            PropertyChanges {target:text;color:'black';}
            PropertyChanges { 
                target:shadow;
                radius:3;
                color: settings.value("title/shadow_color_deactive",'white')
            
            }
            PropertyChanges {target:terminal.anchors;topMargin:title_size;}
        },

        State {
            name: "MAXIMIZED_NOTITLE"
            PropertyChanges {target:text;color:'transparent';}
            PropertyChanges {target:terminal.anchors;topMargin:0;}
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
