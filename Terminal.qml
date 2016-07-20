import QtQuick 2.2
import QMLTermWidget 1.0

QMLTermWidget {

    id: terminal

    anchors.fill: parent
    onTerminalUsesMouseChanged: console.log(terminalUsesMouse);
    onTerminalSizeChanged: console.log(terminalSize);
    enableBold:true
    blinkingCursor:true
    antialiasText:true

    Component.onCompleted:{
        resize(1.0)
        if(command.length>0)
            session.shellProgramArgs=['-c',command]
        session.startShellProgram();
    }

    Scrollbar{
        terminal: terminal
    }
}
