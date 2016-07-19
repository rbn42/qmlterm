import QtQuick 2.2
import QMLTermWidget 1.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.0
import QtGraphicalEffects 1.0


import "utils.js" as Utils

ApplicationWindow {

    property var frameless:"true"==settings.value("window/frameless","true")

    id:root
    flags:frameless? Qt.FramelessWindowHint:Qt.Window
    visible: true
    width: config.width
    height: config.height
    title:mainsession.title
    color: 'transparent'

    Configuration {
        id:config
    }

    Background{
        id:background
        config:config
    }

    WindowState{
        id:state

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
        config:config
    }

    FakeTitle{
        id:faketitle
        config:config
        terminal:terminal
        text.text:mainsession.title
    }

    Terminal{
        id: terminal
        font.family:settings.value("font/family","ubuntu mono")
        font.pointSize: config.font_size
        colorScheme:settings.value("session/color_scheme","Transparent")
        //colorScheme:'BlackOnWhite'
        root:root
        session:mainsession
        Keys.onPressed:if(event.key==Qt.Key_Menu)contextMenu.popup()
        anchors.topMargin:18
    }

    Session{
        id: mainsession
        shellProgram:settings.value("session/shell","bash")
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

    QuitingDialog{id:quiting_dialog}
    
    onClosing:
        if(mainsession.hasActiveProcess)
            close.accepted=quiting_dialog.quit()
    
}
