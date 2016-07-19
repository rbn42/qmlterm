import QtQuick 2.2
import QtGraphicalEffects 1.0

DropShadow {

    property var config

    horizontalOffset: config.shadow_offset
    verticalOffset: config.shadow_offset
    radius: config.shadow_radius
    samples: 17
    color: settings.value("font/shadow_color","black")
    spread:parseFloat(settings.value("font/shadow_spread",0.4))
    visible:"true"==settings.value("font/shadow","true")

    function resize(){
        var scale=config.scale
        scale=scale/1.2
        scale=Math.sqrt(scale)
        scale=scale*1.2

        horizontalOffset=Math.round(config.shadow_offset*scale)
        verticalOffset=Math.round(config.shadow_offset*scale)

        radius=Math.round(config.shadow_radius*scale)
    }
}

