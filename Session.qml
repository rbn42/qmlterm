import QtQuick 2.2
import QMLTermWidget 1.0

QMLTermSession{

    /*historySize*/
/*    shellProgram:config.shell*/
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
