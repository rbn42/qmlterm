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
        shortcut: settings.value("shortcut/newwidonw","")

        onTriggered:{
            launcher.launch(path_terminal,[
                "-c",
                path_configuration,
            ],session.currentDir);
        }
    }

    MenuItem {
        id:filemanager
        text: qsTr('Open File Manger')
        shortcut: settings.value("shortcut/filemanager","")
        visible:"true"==settings.value("menu/filemanager","true")

        onTriggered:{
            var fm=settings.value("shortcut/filemanager","xdg-open")
            launcher.launch(fm,[
                session.currentDir,
            ],session.currentDir);
        }
    }

    MenuItem {
        text: qsTr('&Copy')
        shortcut: settings.value("shortcut/copy","Ctrl+Shift+C")

        onTriggered: terminal.copyClipboard();
    }

    MenuItem {
        text: qsTr('&Paste')
        shortcut: settings.value("shortcut/paste","Ctrl+Shift+V")

        onTriggered: terminal.pasteClipboard();
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
        shortcut: settings.value("shortcut/fullscreen","")

        onTriggered: root.toggleFullscreen();
    }

    MenuItem {
        text: qsTr("&Quit")
        shortcut: settings.value("shortcut/quit","")

        onTriggered:root.close()  
    }

}
