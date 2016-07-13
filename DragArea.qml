import QtQuick 2.2


MouseArea {

    property var root

    anchors.fill: parent;

    property variant clickPos: "1,1"

    onPressed: {
        clickPos  = Qt.point(mouse.x,mouse.y)
    }

    onPositionChanged: {
        var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)
        root.x += delta.x;
        root.y += delta.y;
    }

    onDoubleClicked:root.toggleMaximize()

}
