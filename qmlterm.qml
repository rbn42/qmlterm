import QtQuick 2.2
import QMLTermWidget 1.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.0
import QtGraphicalEffects 1.0


import "utils.js" as Utils

ApplicationWindow {

    flags: Qt.FramelessWindowHint

    Item {
        id:config
        width: settings.value("window/width",960)
        height: settings.value("window/height",480)
        property var scale:parseFloat(settings.value("window/scale",1.0))
        property var font_size:parseInt(settings.value("font/size",12))
        property var shadow_offset:parseInt(settings.value("font/shadow_offset",1))
        property var shadow_radius:parseInt(settings.value("font/shadow_radius",5))
        property var shadow_spread:parseFloat(settings.value("font/shadow_spread",0.4))
        property var animation_duration:parseInt(settings.value("animation/duration",300))
        property var maximized_state:"MAXIMIZED"

    }

    id:root
    visible: true
    width: config.width
    height: config.height
    title:mainsession.title
    color: 'transparent'

    Background{
        id:background
        color:settings.value("window/background_color","black") 
        opacity:settings.value("window/background_opacitiy","1.0")
    }

    WindowState{
        id:state
        config:config
        terminal:terminal
        faketitle:faketitle
        fakeborder:fakeborder
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
        terminal.font.pointSize=Math.round(config.font_size*config.scale);
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
        border.border.width: settings.value("border/width",1)
        shadow.spread:config.shadow_spread 
        shadow.visible:"true"==settings.value("border/shadow","true")
    }

    FakeTitle{
        id:faketitle
        text.font.family:settings.value("title/font","monospace")
        text.text:mainsession.title
        shadow.spread:settings.value("title/shadow_spread",0.6)
    }

    Terminal{
        id: terminal
        font.family:settings.value("font/family","monaco")
        font.pointSize: config.font_size
        colorScheme:settings.value("session/color_scheme","custom")
        //colorScheme:'BlackOnWhite'
        root:root
        session:mainsession
        Keys.onPressed:if(event.key==Qt.Key_Menu)contextMenu.popup()
        anchors.topMargin:18
    }

    Session{
        id: mainsession
        shellProgram:settings.value("session/shell","fish")
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
