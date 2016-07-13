import QMLProcess 1.0
import QtQuick 2.2
import QtQuick.Controls 1.1

import "utils.js" as Utils

Menu {

    property var session
    property var root
    property var terminal

    Launcher { id: launcher }

    MenuItem {
        id:openterminal
        text: qsTr('&Open Terminal')
        onTriggered:{
            console.log(session.foregroundProcessName)
            console.log(session.currentDir)

            launcher.launch('python',[
                Utils.url2path(Qt.resolvedUrl('open_terminal.py')),
                Utils.url2path(Qt.resolvedUrl('run.sh')),
                session.currentDir,
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
        onTriggered: root.resize(1.1)
    }

    MenuItem {
        text: qsTr("Zoom Out")
        shortcut: StandardKey.ZoomOut // "Ctrl+-"
        onTriggered: root.resize(0.9);
    }

    MenuItem {
        text: qsTr('&Full Screen')
        onTriggered: root.toggleFullscreen();
    }

    MenuItem {
        text: qsTr("&Quit")
        onTriggered:root.close() //Qt.quit() 
    }

}
