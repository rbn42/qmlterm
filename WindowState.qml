import QtQuick 2.2

Item{

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
                target:faketitle;
                state:"ACTIVATED"
            }
            PropertyChanges {
                target:fakeborder;
                state:"ACTIVATED"
            }
        },

        State {
            name: "DEACTIVATED"
            PropertyChanges {
                target:background;
                state:"DEACTIVATED"
            }
            PropertyChanges {
                target:faketitle;
                state:"DEACTIVATED"
            }
            PropertyChanges {
                target:fakeborder;
                state:"DEACTIVATED"
            }
        },

        State {
            name: "MAXIMIZED_NOTITLE"
            PropertyChanges {
                target:faketitle;
                state:"MAXIMIZED_NOTITLE"
            }
            PropertyChanges {
                target:fakeborder;
                state:"MAXIMIZED"
            }
        },

        State {
            name: "MAXIMIZED"
            PropertyChanges {
                target:background;
                state:"ACTIVATED"
            }
            PropertyChanges {
                target:faketitle;
                state:"ACTIVATED"
            }
            PropertyChanges {
                target:fakeborder;
                state:"MAXIMIZED"
            }
        }
    ]
}
