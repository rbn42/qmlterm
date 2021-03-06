import QtQuick 2.2

Item {
    width: settings.value("window/width",960)
    height: settings.value("window/height",480)
    property var scale:parseFloat(settings.value("window/scale",1.4))
    property var font_size:settings.value("font/size","12pt")
    property var shadow_offset:parseInt(settings.value("font/shadow_offset",1))
    property var shadow_radius:parseInt(settings.value("font/shadow_radius",5))
    property var animation_duration:parseInt(settings.value("animation/duration",300))
}

