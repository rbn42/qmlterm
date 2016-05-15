import QtQuick 2.2

Item{
    property var shell:"fish" 
    property var font_size:12
    property var font_family:"monaco,WenQuanYi Micro Hei,setofont,Droid Sans Mono for Powerline"   // "Lucida Gr" 
    property var color_scheme:"custom" //cool-retro-term

    property var display_ratio:1.0

    property var title_font:'setofont'
    property var focused_color:'#8ff'
    property var unfocused_color:'#eee'

    property var window_width:960
    property var window_height:480
    property var shadow_radius:5
    property var shadow_offset:1
}
