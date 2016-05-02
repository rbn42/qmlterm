import QMLProcess 1.0
import QtQuick 2.2
import QMLTermWidget 1.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.0
import QtGraphicalEffects 1.0

import "utils.js" as Utils

ApplicationWindow {
    Item{
        id:config
        property var window_width:960
        property var window_height:480
        property var shadow_radius:5
        property var shadow_offset:1
        property var display_ratio:1.4
        property var font_size:12
        property var font_family:"monaco" /* "Lucida Gr" /*"setofont"*/
        property var color_scheme:"custom" /*( "Transparent" /*cool-retro-term"*/
        property var shell:"fish" 

        property var current_window_width
        property var current_window_height
    }

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
            text: qsTr('Open Terminal')
            onTriggered:{
                console.log(mainsession.foregroundProcessName)
                console.log(mainsession.currentDir)

                myLauncher.launch('python',[
                    Utils.url2path(Qt.resolvedUrl('open_terminal.py')),
                    Utils.url2path(Qt.resolvedUrl('run.sh')),
                    mainsession.currentDir,
                ]);
            }
            shortcut:StandardKey.New // "Ctrl+T"
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
    }

    Action{
        onTriggered: searchButton.visible = !searchButton.visible
        shortcut: "Ctrl+F"
    }

    function resize(ratio){
        var resize_window=false;
        if(!config.current_window_width){
            config.current_window_width=config.window_width;
            config.current_window_height=config.window_height;
        }
        if(root.width==config.current_window_width)
            if(root.height==config.current_window_height)
                resize_window=true;

        config.display_ratio*=ratio;

        terminal.font.pointSize=config.font_size*config.display_ratio;
        // Do not resize windows that have been resized manually.
        if(resize_window){
            root.width=config.window_width*config.display_ratio;
            root.height=config.window_height*config.display_ratio;
            config.current_window_width=root.width;
            config.current_window_height=root.height;
        }
        shadow.horizontalOffset=config.shadow_offset*config.display_ratio;
        shadow.verticalOffset=config.shadow_offset*config.display_ratio;
        shadow.radius=config.shadow_radius*config.display_ratio;
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
        Component.onCompleted:{
            resize(1.0)
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
        id:shadow
        anchors.fill: terminal
        horizontalOffset: config.shadow_offset
        verticalOffset: config.shadow_offset
        radius: config.shadow_radius
        samples: 17
        color: "black"
        source: terminal
        spread:0.5
    }
    onClosing:{
        console.log('close')
        if(mainsession.hasActiveProcess){
            close.accepted=false
        }
    }
}

