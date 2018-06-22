import QtQuick 2.2
import QMLTermWidget 1.0

QMLTermWidget {

    property var terminal_margin:settings.value("window/content_margin",1)-1

    anchors.fill: parent
    anchors.leftMargin:terminal_margin
    anchors.rightMargin:terminal_margin
    anchors.bottomMargin:terminal_margin
    anchors.topMargin:terminal_margin
    onTerminalUsesMouseChanged: console.log(terminalUsesMouse);
    onTerminalSizeChanged: console.log(terminalSize);
    enableBold:true
    blinkingCursor:true
    allowDrawLineChar:"true"==settings.value("font/draw_char_line","true")
    lineOffset: settings.value("font/line_offset",0)
    antialiasText:true
    lineSpacing:0
    //fullCursorHeight:true     

    Component.onCompleted:{
        resize(1.0)
        if(command.length>0)
            session.shellProgramArgs=['-c',command]
        session.startShellProgram();
    }
}
