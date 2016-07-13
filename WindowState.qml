import QtQuick 2.2

Item{

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

}
