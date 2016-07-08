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
        color:settings.value("window/background_color","black") 
        opacity:settings.value("window/background_opacitiy","1.0")
    }
    property var current_window_width
    property var current_window_height

    Item {
        id:config2
        width: settings.value("window/width",960)
        height: settings.value("window/height",480)
        property var scale:parseFloat(settings.value("window/scale",1.0))
        property var font_size:parseInt(settings.value("font/size",12))
        property var shadow_offset:parseInt(settings.value("font/shadow_offset",1))
        property var shadow_radius:parseInt(settings.value("font/shadow_radius",5))
    }

    Launcher { id: myLauncher }

    id:root

    visible: true
    width: config2.width
    height: config2.height
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
            text: qsTr('&Copy')
            onTriggered: terminal.copyClipboard();
            //shortcut:StandardKey.Copy  // "Ctrl+C"
            shortcut: "Ctrl+Shift+C"
        }

        MenuItem {
            text: qsTr('&Paste')
            onTriggered: terminal.pasteClipboard();
            //shortcut:StandardKey.Paste // "Ctrl+V"
            shortcut: "Ctrl+Shift+V"
        }

        MenuItem {
            text: qsTr("Zoom &In")
            shortcut: StandardKey.ZoomIn // "Ctrl++"
            onTriggered: resize(1.1)
        }

        MenuItem {
            text: qsTr("Zoom Out")
            shortcut: StandardKey.ZoomOut // "Ctrl+-"
            onTriggered: resize(0.9);
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
            current_window_width=config2.width;
            current_window_height=config2.height;
        }
        if(root.width==current_window_width)
            if(root.height==current_window_height)
                resize_window=true;

        config2.scale*=ratio;

        terminal.font.pointSize=Math.round(config2.font_size*config2.scale);
        // Do not resize windows that have been resized manually.
        if(resize_window){
            root.width=config2.width*config2.scale;
            root.height=config2.height*config2.scale;
            current_window_width=root.width;
            current_window_height=root.height;
        }
        terminalshadow.horizontalOffset=Math.round(config2.shadow_offset*config2.scale)
        terminalshadow.verticalOffset=Math.round(config2.shadow_offset*config2.scale)
        terminalshadow.radius=Math.round(config2.shadow_radius*config2.scale)
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
        font.family:settings.value("font/family","monaco")
        font.pointSize: config2.font_size
        colorScheme:settings.value("session/color_scheme","custom")
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
        shellProgram:settings.value("session/shell","fish")
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
        horizontalOffset: config2.shadow_offset
        verticalOffset: config2.shadow_offset
        radius: config2.shadow_radius
        samples: 17
        color: settings.value("font/shadow_color","black")
        source: terminal
        spread:parseInt(settings.value("font/shadow_spread",0.4))
        visible:"true"==settings.value("font/shadow",true)
    }

    onClosing:{
        console.log('close')
        if(mainsession.hasActiveProcess){
            close.accepted=false
        }
    }
}

