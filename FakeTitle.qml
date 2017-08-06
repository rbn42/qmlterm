import QtQuick 2.2
import QtGraphicalEffects 1.0

Item{

    property var config
    property var fakewindow
    property var enable:"true"==settings.value("title/enable","true")
    property var title_size_:parseInt(settings.value("title/size",18))
    property var title_size:enable?title_size_:0
    property var fontcolor:settings.value("title/color","black")

    property alias shadow:shadow
    property alias text:text

    anchors.fill: parent


    Text {
        id:text

        horizontalAlignment:Text.AlignHCenter
        anchors.fill: parent

        visible:enable
        font.pixelSize:title_size 
        font.family:settings.value("title/font","monospace")
    }

    DropShadow {
        id:shadow

        anchors.fill:text 
        samples: 17
        source:text

        radius:settings.value("title/shadow_radius_active",10)
        visible:enable && ("true"==settings.value("title/shadow","true"))
        spread:settings.value("title/shadow_spread",0.6)
    }

    states: [

        State {
            name: "ACTIVATED"
            PropertyChanges {target:text;color:fontcolor;}
            PropertyChanges { 
                target:shadow;
                //radius:settings.value("title/shadow_radius_active",10)
                color: settings.value("title/shadow_color_active",'white')
            }
            PropertyChanges {target:fakewindow.anchors;topMargin:title_size;}
        },

        State {
            name: "DEACTIVATED"
            PropertyChanges {target:text;color:fontcolor;}
            PropertyChanges { 
                target:shadow;
                //radius:settings.value("title/shadow_radius_deactive",3)
                color: settings.value("title/shadow_color_deactive",'white')
            
            }
            PropertyChanges {target:fakewindow.anchors;topMargin:title_size;}
        },

        State {
            name: "MAXIMIZED_NOTITLE"
            PropertyChanges {target:text;color:'transparent';}
            PropertyChanges {target:fakewindow.anchors;topMargin:0;}
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
