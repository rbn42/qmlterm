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
    }

    function resize(ratio){
        Utils.resize(ratio,config,root)
        fakewindow.terminal_fontsize=Math.round(config.font_size*config.scale);
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

    function switchT(){
        var cmd="bash "+Utils.findFile('select_from_screen.sh',path_terminal)
        stsession.shellProgramArgs=['-c',cmd]
        stsession.startShellProgram();
        st.visible=true
        terminalshadow.source=st
        terminal.visible=false
        st.forceActiveFocus();
    }

    QMLTermSession{
        id:stsession
        shellProgram:"fish"
        onFinished:{
            console.log("ssstitle changed");
            terminal.visible=true
            terminalshadow.source=terminal
            st.visible=false
            terminal.forceActiveFocus();
        }
    }

    Item{
        id:fakewindow
        anchors.fill: parent
        visible:true
        property var terminal_font:settings.value("font/family","ubuntu mono, monospace")
        property var terminal_fontsize:config.font_size

        Terminal{
            id: terminal
            font.family:fakewindow.terminal_font
            font.pointSize:fakewindow.terminal_fontsize
            colorScheme:settings.value("session/color_scheme","Transparent")
            //colorScheme:'BlackOnWhite'
            session:mainsession
            Keys.onPressed:if(event.key==Qt.Key_Menu)contextMenu.popup()
        }

        QMLTermWidget {
            property var terminal_margin:settings.value("window/content_margin",1)-1
            id:st
            font.family:fakewindow.terminal_font
            font.pointSize:fakewindow.terminal_fontsize
            colorScheme:settings.value("session/color_scheme","Transparent")
            //colorScheme:'BlackOnWhite'
            session:stsession
            Keys.onPressed:if(event.key==Qt.Key_Menu)contextMenu.popup()
            anchors.fill: parent
            enableBold:true
            blinkingCursor:true
            antialiasText:true
            visible:false
            anchors.leftMargin:terminal_margin
            anchors.rightMargin:terminal_margin
            anchors.bottomMargin:terminal_margin
            anchors.topMargin:terminal_margin
        }

        TerminalShadow {
            id:terminalshadow
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
