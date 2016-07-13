import QtQuick 2.2

Item{

    property var background

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
            name: "ACTIVATED"
            PropertyChanges {
                target:background;
                state:"ACTIVATED"
            }
        },

        State {
            name: "DEACTIVATED"
            PropertyChanges {
                target:background;
                state:"DEACTIVATED"
            }
        },

        State {
            name: "MAXIMIZED"
            PropertyChanges {
                target:background;
                state:"DEACTIVATED"
            }
        }
    ]
 
}
