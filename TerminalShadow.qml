import QtQuick 2.2
import QtGraphicalEffects 1.0

DropShadow {

    property var config

    horizontalOffset: config.shadow_offset
    verticalOffset: config.shadow_offset
    radius: config.shadow_radius
    samples: 17
    color: settings.value("font/shadow_color","black")
    spread:config.shadow_spread
    visible:"true"==settings.value("font/shadow",true)

    function resize(){
        horizontalOffset=Math.round(config.shadow_offset*config.scale)
        verticalOffset=Math.round(config.shadow_offset*config.scale)
        radius=Math.round(config.shadow_radius*config.scale)
    }
}

