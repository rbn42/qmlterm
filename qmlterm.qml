import QtQuick 2.2
import QMLTermWidget 1.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.0
import QtGraphicalEffects 1.0


import "utils.js" as Utils

ApplicationWindow {

    id:root
    flags: Qt.FramelessWindowHint
    visible: true
    width: config.window_width
    height: config.window_height
    title:mainsession.title
    color: 'transparent'

    Configuration{id:config}

    Background{
        id:background
        config:config
    }

    WindowState{
        id:state

        terminal:terminal
        faketitle:faketitle
        fakeborder:fakeborder
        background:background
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

    DragArea{root:root}

    FakeBorder{
        id:fakeborder
        config:config
    }

    FakeTitle{
        id:faketitle
        config:config
        text.font.family:config.title_font 
        text.text:mainsession.title
        shadow.spread:config.title_shadow_spread
    }

    Terminal{
        id: terminal
        font.family:config.font_family
        font.pointSize: config.font_size
        colorScheme:config.color_scheme
        //colorScheme:'BlackOnWhite'
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
    

    onClosing:{
        console.log('close')
        if(mainsession.hasActiveProcess){
            close.accepted=false
        }
    }
    
}
