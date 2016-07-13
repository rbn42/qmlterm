import QtQuick 2.2
import QMLTermWidget 1.0

QMLTermWidget {

    property var root

    function setTitle(title){
        root.title=title
    }

    id: terminal

    anchors.fill: parent
    onTerminalUsesMouseChanged: console.log(terminalUsesMouse);
    onTerminalSizeChanged: console.log(terminalSize);
    enableBold:true
    blinkingCursor:true
    antialiasText:true
    Component.onCompleted:{

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
            session.shellProgramArgs=['-c',args]
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

