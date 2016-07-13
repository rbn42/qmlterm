import QtQuick 2.2
import QMLTermWidget 1.0

QMLTermWidget {

    property var root

    function setTitle(title){
        //root.title=title
        //faketitle.text=title
    }

    id: terminal

    anchors.fill: parent
    onTerminalUsesMouseChanged: console.log(terminalUsesMouse);
    onTerminalSizeChanged: console.log(terminalSize);
    enableBold:true
    blinkingCursor:true
    antialiasText:true
    Component.onCompleted:{

        resize(1.0)
        if(command.length>0){
            setTitle(command)
            session.shellProgramArgs=['-c',command]
        }

        session.startShellProgram();

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

