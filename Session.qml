import QtQuick 2.2
import QMLTermWidget 1.0

QMLTermSession{

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
