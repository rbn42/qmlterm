import QtQuick 2.2
import QMLTermWidget 1.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.0
import QtGraphicalEffects 1.0


import "utils.js" as Utils

ApplicationWindow {

    flags: Qt.FramelessWindowHint

    id:root

    visible: true
    width: config.window_width
    height: config.window_height
    title:mainsession.title

    function borderstate(_active,_visibility){
        if(_visibility==4){// "Maximized")
            bordershadow.state=config.maximized_state //"MAXIMIZED"
        }else if(_visibility==5){// "Full Screen")
            bordershadow.state=config.maximized_state //#"MAXIMIZED"
        }else if(_active){
            bordershadow.state="ACTICATED"
        }else{
            bordershadow.state="DEACTIVATED"
        }
    }

    color:'transparent' 

    Rectangle{
        anchors.fill: parent
        color: "cyan"
        //ColorAnimation on color { to: "transparent"; duration: 500 }
        NumberAnimation on opacity { to: 0; duration: 0 }
        opacity:0.5
    }

    onActiveChanged:{
        borderstate(active,root.visibility)
    }
    onVisibilityChanged:{
        borderstate(active,visibility)
    }

    Configuration{id:config}

    Background{
        id:background
        config:config
    }

    ContextMenu{
        id: contextMenu
        session:mainsession
        root:root
        terminal:terminal
    }

    function resize(ratio){
        Utils.resize(ratio,config,root)

        terminal.font.pointSize=Math.round(config.font_size*config.display_ratio);
        terminalshadow.resize()
    }

    function toggleMaximize(){
            console.log(root.visibility)
            if(root.visibility==4)// "Maximized")
                root.visibility='AutomaticVisibility'
            else
                root.visibility= "Maximized"
    }

    function toggleFullscreen(){
            console.log(root.visibility)
            if(root.visibility==5)// "FullScreen")
                root.visibility='AutomaticVisibility'
            else
                root.visibility= "FullScreen"
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: contextMenu.popup()  
    }

    MouseArea {
        anchors.fill: parent;
        property variant clickPos: "1,1"
        onPressed: {
            clickPos  = Qt.point(mouse.x,mouse.y)
        }
        onPositionChanged: {
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
            root.x += delta.x;
            root.y += delta.y;
        }
        onDoubleClicked:toggleMaximize()
        


    }

    Rectangle{
        id:fakeborder
        //anchors.topMargin:config.frame_border-1
        //anchors.rightMargin:config.frame_border-1
        //anchors.leftMargin:config.frame_border-1
        //anchors.bottomMargin:config.frame_border-1
        border.color: "black"
        border.width: config.frame_border
        anchors.fill: parent
        color:'transparent'
    }

    Text {
        id:faketitle
        font.family:config.title_font 
        horizontalAlignment:Text.AlignHCenter
        anchors.fill: parent
        text:mainsession.title
        color: "black"
        font.pixelSize: 18
    }

    Terminal{
        id: terminal
        config:config
        root:root
        session:mainsession
        Keys.onPressed:if(event.key==Qt.Key_Menu)contextMenu.popup()
        anchors.topMargin:18
    }

    Session{
        id: mainsession
        shellProgram:config.shell
    }

    Component.onCompleted:{
        resize(1.0)
        terminal.forceActiveFocus();
    }
    
    TerminalShadow {
        id:terminalshadow
        config:config
        anchors.fill: terminal
        source: terminal
    }
    
    DropShadow {
        id:titleshadow
        anchors.fill: faketitle //   radius: 15
        samples: 17
        color: "white"
        source: faketitle
        spread:config.title_shadow_spread
    }

    DropShadow {
        id:bordershadow
        anchors.fill: fakeborder
       // radius: 5
        samples: 17
        color: "black"
        source: fakeborder
        spread:config.shadow_spread 
        visible:config.enable_border_shadow

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

    onClosing:{
        console.log('close')
        if(mainsession.hasActiveProcess){
            close.accepted=false
        }
    }
    
}
