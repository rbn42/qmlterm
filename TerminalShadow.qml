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

    property var delay:false

    function _resize(){
        var scale=config.scale
        scale=scale/1.2
        scale=Math.sqrt(scale)
        scale=scale*1.2

        horizontalOffset=Math.round(config.shadow_offset*scale)
        verticalOffset=Math.round(config.shadow_offset*scale)

        //qt升级后这里可能crash
        radius=Math.round(config.shadow_radius*scale)
    }

    function resize(){
        if(delay){
            timer_resize.start();
        }else{
            delay=true;
            _resize();
        }
    }
    //用timer延迟resize效果,避免crash
    //因为新版本qt在shadow resize过快的情况下会崩溃,所以加个timer缓冲
    //timer在运行中重复start是无效的,所以会减少resize的次数
    Timer {
        id:timer_resize
        interval: 5000; running: false; repeat: false
        onTriggered: _resize()
    }

}

