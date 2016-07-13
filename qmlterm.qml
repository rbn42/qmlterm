import QtQuick 2.2
import QMLTermWidget 1.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.0
import QtGraphicalEffects 1.0

import "utils.js" as Utils

ApplicationWindow {

    id:root

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

    ContextMenu{
        id: contextMenu
        session:mainsession
        root:root
        terminal:terminal
    }

    function resize(ratio){
        var resize_window=Utils.resize(ratio,config,root)

        // Do not resize windows that have been resized manually.

        terminal.font.pointSize=Math.round(config.font_size*config.display_ratio);
        terminalshadow.resize()

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

    Terminal{
        id: terminal
        config:config
        root:root
        session:mainsession
        Keys.onPressed:if(event.key==Qt.Key_Menu)contextMenu.popup()
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

