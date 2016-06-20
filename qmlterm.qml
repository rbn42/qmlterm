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

    function borderstate(_active,_visibility){
        if(_visibility==4){// "Maximized")
            bordershadow.state=config.maximized_state //"MAXIMIZED"
        }else if(_visibility==5){// "Full Screen")
            bordershadow.state=config.maximized_state //#"MAXIMIZED"
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
        border.width: config.frame_border
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
        visible:config.enable_shadow
    }
    
    DropShadow {
        id:titleshadow
        anchors.fill: faketitle //   radius: 15
        samples: 17
        color: "white"
        source: faketitle
        spread:config.title_shadow_spread
    }

    DropShadow {
        id:bordershadow
        anchors.fill: fakeborder
       // radius: 5
        samples: 17
        color: "black"
        source: fakeborder
        spread:config.shadow_spread 
        visible:config.enable_border_shadow

        states: [
            State {
                name: "DEACTIVATED"
                PropertyChanges {
                    target:fakeborder.border;
                    width:1;
                    color:config.border_color_deactive
                }
                PropertyChanges { 
                    target: bordershadow;
                    radius:config.border_shadow_deactive;
                    color:config.border_color_deactive
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
                    color:config.border_color_active
                }
                PropertyChanges { 
                    target: bordershadow;
                    radius:config.border_shadow_active;
                    color:config.border_color_active
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
                    duration:config.animation_duration
                }
                ColorAnimation { target: bordershadow; 
                    duration: config.animation_duration
                }
                ColorAnimation { target: titleshadow; 
                    duration: config.animation_duration 
                }
                NumberAnimation {target:bordershadow;
                    properties: "radius";
                    duration:config.animation_duration 
                }
                NumberAnimation {target:titleshadow;
                    properties: "radius";
                    duration:config.animation_duration 
                }
    // easing.type: Easing.InOutQuad }
            },
            Transition {
                from: "ACTICATED"
                to: "DEACTIVATED"
                ColorAnimation { target: fakeborder.border; 
                    duration:config.animation_duration
                }
                ColorAnimation { target: bordershadow; 
                    duration:config.animation_duration
                }
                ColorAnimation { target: titleshadow; 
                    duration:config.animation_duration 
                }
                NumberAnimation {target:bordershadow;
                    properties: "radius";duration: config.animation_duration
                }
                NumberAnimation {target:titleshadow;
                    properties: "radius";duration: config.animation_duration
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
