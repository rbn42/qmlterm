import QtQuick 2.2
import QtQuick.Dialogs 1.1

MessageDialog {

    id:dialog
    title:"Quit"
    text:"There are running processes.\nDo you really want to quit?"
    standardButtons: StandardButton.No | StandardButton.Yes

    property var quit_accepted:false
    onYes:{
        quit_accepted=true
        Qt.quit()
    }

    function quit(){
        if("true"!=settings.value("prompt/quiting","true"))
            return false
        if(quit_accepted)
            return true
        dialog.open()
        return false
    }
}
