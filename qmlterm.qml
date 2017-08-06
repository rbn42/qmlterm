import QtQuick 2.2
import QMLTermWidget 1.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.0
import QtGraphicalEffects 1.0


import "utils.js" as Utils

ApplicationWindow {

    id:root
    flags: eval(settings.value("window/flags","Qt.FramelessWindowHint")) 
    visible: true
    width: config.width
    height: config.height
    title:mainsession.title
    x: settings.value("window/x",null)
    y: settings.value("window/y",null)
    color: 'transparent'

    Configuration {id:config}

    Background{
        id:background
        config:config
    }

    WindowState{
        id:state

        faketitle:faketitle
        fakeborder:fakeborder
        background:background
        scrollbar:scrollbar
    }

    visibility:settings.value('window/state','AutomaticVisibility')

    onActiveChanged:state.changestate(active,root.visibility)

    onVisibilityChanged:state.changestate(active,visibility)

    ContextMenu{
        id: contextMenu
        session:mainsession
        root:root
        terminal:terminal
        background:background
        faketitle:faketitle
        fakeborder:fakeborder
    }

    function resize(ratio){
        Utils.resize(ratio,config,root)
        terminal.font.pointSize=Math.round(config.font_size*config.scale);
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


    FakeBorder{
        id:fakeborder
        config:config
    }

    FakeTitle{
        id:faketitle
        config:config
        fakewindow:fakewindow
        text.text:mainsession.title
        DragArea{root:root}
    }

    Item{
        id:fakewindow
        anchors.fill: parent
        visible:true

        Terminal{
            id: terminal
            font.family:settings.value("font/family","monospace")
            font.pointSize: config.font_size
            colorScheme:settings.value("session/color_scheme","Transparent")
            //colorScheme:'BlackOnWhite'
            session:mainsession
            Keys.onPressed:if(event.key==Qt.Key_Menu)contextMenu.popup()
        }

        TerminalShadow {
            config:config
            anchors.fill: terminal
            source: terminal
        }

        Scrollbar{
            id:scrollbar
            terminal: terminal
        }
    }


    Session{
        id: mainsession
        shellProgram:settings.value("session/shell","bash")
    }

    Component.onCompleted:{
        resize(1.0)
        terminal.forceActiveFocus();
    }

    QuitingDialog{id:quiting_dialog}
    
    onClosing:
        if(mainsession.hasActiveProcess)
            close.accepted=quiting_dialog.quit()
    
}
