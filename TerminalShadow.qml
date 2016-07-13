import QtQuick 2.2
import QtGraphicalEffects 1.0

DropShadow {

    property var config

    horizontalOffset: config.shadow_offset
    verticalOffset: config.shadow_offset
    radius: config.shadow_radius
    samples: 17
    color: config.shadow_color
    source: terminal
    spread:config.shadow_spread
    visible:config.enable_shadow

    function resize(){
        terminalshadow.horizontalOffset=Math.round(config.shadow_offset*config.display_ratio)
        terminalshadow.verticalOffset=Math.round(config.shadow_offset*config.display_ratio)
        terminalshadow.radius=Math.round(config.shadow_radius*config.display_ratio)
    }
}

