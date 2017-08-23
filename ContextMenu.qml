import QMLProcess 1.0
import QtQuick 2.2
import QtQuick.Controls 1.1

import "utils.js" as Utils

Menu {

    property var session
    property var root
    property var terminal
    property var background
    property var faketitle
    property var fakeborder

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
        text: qsTr('Open &File Manger')
        shortcut: settings.value("shortcut/filemanager","")
        visible:"true"==settings.value("menu/filemanager","true")

        onTriggered:{
            var fm=settings.value("system/filemanager","xdg-open")
            launcher.launch(fm,[
                session.currentDir,
            ],session.currentDir);
        }
    }

    MenuSeparator { }

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

    MenuSeparator { }

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
        text: qsTr("Increase Opacity")
        shortcut: settings.value("shortcut/inc_opacity","Ctrl+PgUp")

        onTriggered: background.increase_opacity();
    }

    MenuItem {
        text: qsTr("Decrease Opacity")
        shortcut: settings.value("shortcut/dec_opacity","Ctrl+PgDown")

        onTriggered: background.decrease_opacity();
    }


    MenuSeparator { }

    MenuItem {
        text: qsTr("&Maximize")

        onTriggered:root.toggleMaximize()  
    }

    MenuItem {
        text: qsTr("Mi&nimize")

        onTriggered:root.visibility= "Minimized"
    }

    MenuItem {
        text: qsTr('Full Screen')
        shortcut: settings.value("shortcut/fullscreen","")

        onTriggered: root.toggleFullscreen();
    }

    MenuSeparator { }

    MenuItem {
        text: qsTr("Toggle Title")
        onTriggered:faketitle.enable=!faketitle.enable
    }

    MenuItem {
        text: qsTr("Toggle &Border")
        onTriggered:fakeborder.enable=!fakeborder.enable
    }


    MenuSeparator { }

    MenuItem {
        text: qsTr("&Quit")
        shortcut: settings.value("shortcut/quit","")

        onTriggered:root.close()  
    }

}
