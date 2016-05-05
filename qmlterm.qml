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

        property var shell:"fish" 
        property var font_size:12
        property var font_family:"monaco" // "Lucida Gr" "setofont"
        property var color_scheme:"custom" //cool-retro-term

        property var display_ratio:1.2

        property var title_font:'setofont'
        property var focused_color:'#8ff'
        property var unfocused_color:'#eee'

        property var window_width:960
        property var window_height:480
        property var shadow_radius:5
        property var shadow_offset:1

        property var current_window_width
        property var current_window_height
    }

    Launcher { id: myLauncher }

    id:root

    visible: true
    width: config.window_width
    height: config.window_height
    title:mainsession.title


    onActiveChanged:{
        if(active){
            bordershadow.state="ACTICATED"
        }else{
            bordershadow.state="DEACTIVATED"
        }
    }
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
        shadow1.horizontalOffset=config.shadow_offset*config.display_ratio;
        shadow1.verticalOffset=config.shadow_offset*config.display_ratio;
        shadow1.radius=config.shadow_radius*config.display_ratio;
    }


    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: contextMenu.popup()  
    }

    color: 'transparent'
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
        onDoubleClicked:{
            console.log(root.visibility)
            if(root.visibility==4)// "Maximized")
                root.visibility='AutomaticVisibility'
            else
                root.visibility= "Maximized"
        }


    }

    Rectangle{
        id:fakeborder
        anchors.topMargin:-1
        anchors.rightMargin:-1
        anchors.leftMargin:-1
        anchors.bottomMargin:-1
        border.color: "black"
        border.width: 1
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

    QMLTermWidget {

        Keys.onPressed:if(event.key==Qt.Key_Menu)contextMenu.popup()
        id: terminal
        anchors.fill: parent
        anchors.topMargin:18
        font.family:config.font_family
        font.pointSize: config.font_size
        colorScheme:config.color_scheme
        //colorScheme:'BlackOnWhite'
        session:mainsession
        onTerminalUsesMouseChanged: console.log(terminalUsesMouse);
        onTerminalSizeChanged: console.log(terminalSize);
        enableBold:true
        blinkingCursor:true
        antialiasText:true
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
        id:shadow1
        anchors.fill: terminal
        horizontalOffset: config.shadow_offset
        verticalOffset: config.shadow_offset
        radius: config.shadow_radius
        samples: 17
        color: "black"
        source: terminal
        spread:0.5
    }
    DropShadow {
        id:titleshadow
        anchors.fill: faketitle
     //   radius: 15
        samples: 17
        color: "white"
        source: faketitle
        spread:0.8
    }
    DropShadow {
        id:bordershadow
        anchors.fill: fakeborder
       // radius: 5
        samples: 17
        color: "black"
        source: fakeborder
        spread:0.5

        states: [
            State {
                name: "DEACTIVATED"
                PropertyChanges { target: bordershadow;radius:1;}//color:'black'}// color:config.unfocused_color }
                PropertyChanges { target: titleshadow; radius:3;}//color:config.unfocused_color }
            },
            State {
                name: "ACTICATED"
                PropertyChanges { target: bordershadow;radius:5;}//color:'black'}// color:config.focused_color }
                PropertyChanges { target: titleshadow;radius:10;}// color:'white'}//config.focused_color }
            }
        ]


        transitions: [
            Transition {
                from: "DEACTIVATED"
                to: "ACTICATED"
                ColorAnimation { target: bordershadow; duration: 500}
                ColorAnimation { target: titleshadow; duration: 500}
                NumberAnimation {target:bordershadow;properties: "radius";duration: 300}
                NumberAnimation {target:titleshadow;properties: "radius";duration: 300}
    // easing.type: Easing.InOutQuad }
            },
            Transition {
                from: "ACTICATED"
                to: "DEACTIVATED"
                ColorAnimation { target: bordershadow; duration: 500}
                ColorAnimation { target: titleshadow; duration: 500}
                NumberAnimation {target:bordershadow;properties: "radius";duration: 300}
                NumberAnimation {target:titleshadow;properties: "radius";duration: 300}
                // easing.type: Easing.InOutQuad }
            }
        ]
    }
    onClosing:{
        console.log('close')
        if(mainsession.hasActiveProcess){
            close.accepted=false
        }
    }

}

