import QMLProcess 1.0
import QtQuick 2.2
import QMLTermWidget 1.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.0
import QtGraphicalEffects 1.0

import "utils.js" as Utils

ApplicationWindow {

    Rectangle{
        anchors.fill: parent
        color: config.background_color
        opacity:config.background_opacitiy
    }
    property var current_window_width
    property var current_window_height
    Configuration{id:config}
    Launcher { id: myLauncher }

    id:root

    visible: true
    width: config.window_width
    height: config.window_height
    title:mainsession.title

    color: 'transparent'

    Menu { id: contextMenu
        MenuItem {
            id:openterminal
            text: qsTr('&Open Terminal')
            onTriggered:{
                console.log(mainsession.foregroundProcessName)
                console.log(mainsession.currentDir)

                myLauncher.launch('python',[
                    Utils.url2path(Qt.resolvedUrl('open_terminal.py')),
                    Utils.url2path(Qt.resolvedUrl('run.sh')),
                    mainsession.currentDir,
                ]);
            }
            //shortcut:StandardKey.New // "Ctrl+T"
        }
        MenuItem {
            text: qsTr('Copy')
            onTriggered: terminal.copyClipboard();
            //shortcut:StandardKey.Copy  // "Ctrl+Shift+C"
            shortcut: "Ctrl+Shift+C"
        }
        MenuItem {
            text: qsTr('Paste')
            onTriggered: terminal.pasteClipboard();
            //shortcut:StandardKey.Paste // "Ctrl+Shift+V"
            shortcut: "Ctrl+Shift+V"
        }
        MenuItem {
            text: qsTr("Zoom In")
            shortcut: StandardKey.ZoomIn// "Ctrl++"
            onTriggered:        resize(1.1)
        }
        MenuItem {
            text: qsTr("Zoom Out")
            shortcut:StandardKey.ZoomOut// "Ctrl+-"
            onTriggered:                resize(0.9);
        }
        MenuItem {
            text: qsTr("&Quit")
            onTriggered:root.close() //Qt.quit() 
        }
    }

    Action{
        onTriggered: searchButton.visible = !searchButton.visible
        shortcut: "Ctrl+F"
    }

    function resize(ratio){
        var resize_window=false;
        if(!current_window_width){
            current_window_width=config.window_width;
            current_window_height=config.window_height;
        }
        if(root.width==current_window_width)
            if(root.height==current_window_height)
                resize_window=true;

        config.display_ratio*=ratio;

        terminal.font.pointSize=Math.round(config.font_size*config.display_ratio);
        // Do not resize windows that have been resized manually.
        if(resize_window){
            root.width=config.window_width*config.display_ratio;
            root.height=config.window_height*config.display_ratio;
            current_window_width=root.width;
            current_window_height=root.height;
        }
        terminalshadow.horizontalOffset=Math.round(config.shadow_offset*config.display_ratio)
        terminalshadow.verticalOffset=Math.round(config.shadow_offset*config.display_ratio)
        terminalshadow.radius=Math.round(config.shadow_radius*config.display_ratio)
    }
    function setTitle(title){
        root.title=title
    }


    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: contextMenu.popup()  
    }

    QMLTermWidget {

        Keys.onPressed:if(event.key==Qt.Key_Menu)contextMenu.popup()
        id: terminal
        anchors.fill: parent
        font.family:config.font_family
        font.pointSize: config.font_size
        colorScheme:config.color_scheme
        session:mainsession
        onTerminalUsesMouseChanged: console.log(terminalUsesMouse);
        onTerminalSizeChanged: console.log(terminalSize);
        enableBold:true
        blinkingCursor:true
        antialiasText:true
        Component.onCompleted:{
            resize(1.0)

            var args=[]
            for(var i=0;i<Qt.application.arguments.length;i++){
                var s=Qt.application.arguments[i] 
                if (s=='-e'){
                    i+=1
                    s=Qt.application.arguments[i] 
                    args.push(s)
                }else if (s.indexOf('--command=')==0){
                    s=s.substr('--command='.length)
                    args.push(s)
                }
            }
            if (args.length>0){
                args=args.join(' ')
                console.log(args);
                setTitle(args)
                mainsession.shellProgramArgs=['-c',args]
            }

            mainsession.startShellProgram();
        }

        QMLTermScrollbar {
            terminal: terminal
            width: 20
            Rectangle {
                opacity: 0.4
                anchors.margins: 5
                radius: width * 0.5
                anchors.fill: parent
            }
        }

    }

    QMLTermSession{
        id: mainsession
        /*historySize*/
        shellProgram:config.shell
        //shellProgramArgs:['--rcfile','~/apps/qmlterm/bashrc']
        /*title*/
        initialWorkingDirectory: "$PWD"
        onMatchFound: {
            console.log("found at: %1 %2 %3 %4".arg(startColumn).arg(startLine).arg(endColumn).arg(endLine));
        }
        onNoMatchFound: {
            console.log("not found");
        }
        onTitleChanged:{
            console.log("title changed");
        }
        onFinished:{
            Qt.quit()
        }
    }
    Button {
        id: searchButton
        text: "Find version"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        visible: false
        onClicked: mainsession.search("version");
    }
    Component.onCompleted: terminal.forceActiveFocus();
    DropShadow {
        id:terminalshadow
        anchors.fill: terminal
        horizontalOffset: config.shadow_offset
        verticalOffset: config.shadow_offset
        radius: config.shadow_radius
        samples: 17
        color: "black"
        source: terminal
        spread:config.shadow_spread
    }
    onClosing:{
        console.log('close')
        if(mainsession.hasActiveProcess){
            close.accepted=false
        }
    }
}

