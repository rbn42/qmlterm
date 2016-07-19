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
            launcher.launch('python',[
                Utils.findFile('open_terminal.py',path_terminal),
                path_terminal,
                path_configuration,
                session.currentDir,
            ]);
        }
        shortcut: settings.value("shortcut/newwidonw","")
    }

    MenuItem {
        text: qsTr('&Copy')
        onTriggered: terminal.copyClipboard();
        shortcut: settings.value("shortcut/copy","Ctrl+Shift+C")
    }

    MenuItem {
        text: qsTr('&Paste')
        onTriggered: terminal.pasteClipboard();
        shortcut: settings.value("shortcut/paste","Ctrl+Shift+V")
    }

    MenuItem {
        text: qsTr('Copy Screen To &Vim')
        visible:"true"==settings.value("menu/copyscreen","false")
        onTriggered:{
            //Copy the screen to clipboard
            terminal.copyScreenClipboard();

            launcher.launch('bash',[
                Utils.findFile('select_from_screen.sh',path_terminal),
            ]);
        }
    }

    MenuItem {
        text: qsTr("Zoom &In")
        shortcut: settings.value("shortcut/zoomin","Ctrl++")
        onTriggered: root.resize(1.1)
    }

    MenuItem {
        text: qsTr("Zoom Out")
        shortcut: settings.value("shortcut/zoomout","Ctrl+-")
        onTriggered: root.resize(1.0/1.1);
    }

    MenuItem {
        text: qsTr("&Maximize")
        onTriggered:root.toggleMaximize()  
    }

    MenuItem {
        text: qsTr("Mi&nimize")
        onTriggered:root.visibility= "Minimized"
    }

    MenuItem {
        text: qsTr('&Full Screen')
        onTriggered: root.toggleFullscreen();
    }

    MenuItem {
        text: qsTr("&Quit")
        onTriggered:root.close()  
        shortcut: settings.value("shortcut/quit","")
    }

}
