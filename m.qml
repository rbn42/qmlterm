
Menu { id: contextMenu
    MenuItem {
        id:openterminal
        text: qsTr('&Open Terminal')
        onTriggered:{
            console.log(mainsession.foregroundProcessName)
            console.log(mainsession.currentDir)

            myLauncher.launch('python',[
                Utils.url2path(Qt.resolvedUrl('open_terminal.py')),
                Utils.url2path(Qt.resolvedUrl('run.sh')),
                mainsession.currentDir,
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
        text: qsTr('Copy Screen To &Vim')
        onTriggered:{
            //Copy the screen to clipboard
            terminal.copyScreenClipboard();

            myLauncher.launch('bash',[
                Utils.url2path(Qt.resolvedUrl('select_from_screen.sh')),
            ]);
        }
    }

    MenuItem {
        text: qsTr("Zoom &In")
        shortcut: StandardKey.ZoomIn // "Ctrl++"
        onTriggered: resize(1.1)
    }

    MenuItem {
        text: qsTr("Zoom Out")
        shortcut: StandardKey.ZoomOut // "Ctrl+-"
        onTriggered: resize(0.9);
    }
