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
    color: 'transparent'

    Rectangle{
        anchors.fill: parent
        color: "cyan"
        //ColorAnimation on color { to: "transparent"; duration: 500 }
        NumberAnimation on opacity { to: 0; duration: 0 }
        opacity:0.5
    }

    Configuration{id:config}

    Background{
        id:background
        config:config
    }

    WindowState{
        id:state
        config:config
        terminal:terminal
        faketitle:faketitle
        titleshadow:titleshadow
        fakeborder:fakeborder
        bordershadow:bordershadow
    }

    onActiveChanged:{
        state.changestate(active,root.visibility)
    }

    onVisibilityChanged:{
        state.changestate(active,visibility)
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

    }

    onClosing:{
        console.log('close')
        if(mainsession.hasActiveProcess){
            close.accepted=false
        }
    }
    
}
