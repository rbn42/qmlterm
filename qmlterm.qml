import QMLProcess 1.0
import QtQuick 2.2
import QMLTermWidget 1.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.0
import QtGraphicalEffects 1.0


import "utils.js" as Utils

ApplicationWindow {

    flags: Qt.FramelessWindowHint

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
        property var shadow_spread:parseFloat(settings.value("font/shadow_spread",0.4))
        property var animation_duration:parseInt(settings.value("animation/duration",300))
        property var maximized_state:"MAXIMIZED"

    }

    Launcher { id: myLauncher }

    id:root

    visible: true
    width: config2.width
    height: config2.height
    title:mainsession.title

    function borderstate(_active,_visibility){
        if(_visibility==4){// "Maximized")
            bordershadow.state=config2.maximized_state //"MAXIMIZED"
        }else if(_visibility==5){// "Full Screen")
            bordershadow.state=config2.maximized_state //#"MAXIMIZED"
        }else if(_active){
            bordershadow.state="ACTICATED"
        }else{
            bordershadow.state="DEACTIVATED"
        }
    }

    color:'transparent' 
    Rectangle{
        anchors.fill: parent
        color: "cyan"
        //ColorAnimation on color { to: "transparent"; duration: 500 }
        NumberAnimation on opacity { to: 0; duration: 0 }
        opacity:0.5
    }

    onActiveChanged:{
        borderstate(active,root.visibility)
    }
    onVisibilityChanged:{
        borderstate(active,visibility)
    }

    Menu { 
        id: contextMenu
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
            text: qsTr('Copy Screen To &Vim')
            onTriggered:{
                //Copy the screen to clipboard
                terminal.copyScreenClipboard();

                myLauncher.launch('bash',[
                    Utils.url2path(Qt.resolvedUrl('select_from_screen.sh')),
                ]);
            }
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
            text: qsTr("&Maximize")
            onTriggered:toggleMaximize()  
        }

        MenuItem {
            text: qsTr("Mi&nimize")
            onTriggered:root.visibility= "Minimized"
        }

        MenuItem {
            text: qsTr('&Full Screen')
            onTriggered: toggleFullscreen();
        }

        MenuItem {
            text: qsTr("&Quit")
            onTriggered:root.close() 
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
    function toggleMaximize(){
            console.log(root.visibility)
            if(root.visibility==4)// "Maximized")
                root.visibility='AutomaticVisibility'
            else
                root.visibility= "Maximized"
    }
    function setTitle(title){
        //root.title=title
        //faketitle.text=title
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
        onDoubleClicked:toggleMaximize()
        


    }

    Rectangle{
        id:fakeborder
        //anchors.topMargin:config.frame_border-1
        //anchors.rightMargin:config.frame_border-1
        //anchors.leftMargin:config.frame_border-1
        //anchors.bottomMargin:config.frame_border-1
        border.color: "black"
        border.width: settings.value("border/width",1)
        anchors.fill: parent
        color:'transparent'
    }

    Text {
        id:faketitle
        font.family:settings.value("title/font","monospace")
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
            if(command.length>0){
                setTitle(command)
                mainsession.shellProgramArgs=['-c',command]
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
        spread:config2.shadow_spread
        visible:"true"==settings.value("font/shadow",true)
    }
    
    DropShadow {
        id:titleshadow
        anchors.fill: faketitle //   radius: 15
        samples: 17
        color: "white"
        source: faketitle
        spread:settings.value("title/shadow_spread",0.6)
    }

    DropShadow {
        id:bordershadow
        anchors.fill: fakeborder
       // radius: 5
        samples: 17
        color: "black"
        source: fakeborder
        spread:config2.shadow_spread 
        visible:"true"==settings.value("border/shadow","true")

        states: [
            State {
                name: "DEACTIVATED"
                PropertyChanges {
                    target:fakeborder.border;
                    width:1;
                    color:settings.value("border/deactive_color","")
                }
                PropertyChanges { 
                    target: bordershadow;
                    radius:settings.value("border/deactive_shadow",0);
                    color:settings.value("border/deactive_color","")
                }
                PropertyChanges {target:faketitle;color:'black';}
                PropertyChanges { target: titleshadow; radius:3;}
                PropertyChanges {target:terminal.anchors;topMargin:18;}
            },
            State {
                name: "ACTICATED"
                PropertyChanges {
                    target:fakeborder.border;
                    width:1;
                    color:settings.value("border/active_color","")
                }
                PropertyChanges { 
                    target: bordershadow;
                    radius:settings.value("border/active_shadow",0);
                    color:settings.value("border/active_color","")
                }
                PropertyChanges {target:faketitle;color:'black';}
                PropertyChanges { target: titleshadow;radius:10;}
                PropertyChanges {target:terminal.anchors;topMargin:18;}
            },
            State {
                name: "MAXIMIZED_NOTITLE"
                PropertyChanges {target:fakeborder.border;width:0;}
                PropertyChanges {target:faketitle;color:'transparent';}
                PropertyChanges {target:terminal.anchors;topMargin:0;}
            },
            State {
                name: "MAXIMIZED"
                PropertyChanges {target:fakeborder.border;width:0;}
            }
        ]

        transitions: [
            Transition {
                from: "DEACTIVATED"
                to: "ACTICATED"
                ColorAnimation { target: fakeborder.border; 
                    duration:config2.animation_duration
                }
                ColorAnimation { target: bordershadow; 
                    duration: config2.animation_duration
                }
                ColorAnimation { target: titleshadow; 
                    duration: config2.animation_duration 
                }
                NumberAnimation {target:bordershadow;
                    properties: "radius";
                    duration:config2.animation_duration 
                }
                NumberAnimation {target:titleshadow;
                    properties: "radius";
                    duration:config2.animation_duration 
                }
    // easing.type: Easing.InOutQuad }
            },
            Transition {
                from: "ACTICATED"
                to: "DEACTIVATED"
                ColorAnimation { target: fakeborder.border; 
                    duration:config2.animation_duration
                }
                ColorAnimation { target: bordershadow; 
                    duration:config2.animation_duration
                }
                ColorAnimation { target: titleshadow; 
                    duration:config2.animation_duration 
                }
                NumberAnimation {target:bordershadow;
                    properties: "radius";duration: config2.animation_duration
                }
                NumberAnimation {target:titleshadow;
                    properties: "radius";duration: config2.animation_duration
                }
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
