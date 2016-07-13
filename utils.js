function url2path(url) {
    var prefix = 'file://';
    return url.substring(prefix.length);
}

function subhome(home, path) {
    return path;
}

var current_window_width
var current_window_height

function resize(ratio,config) {
    var resize_window = false;
    if (!current_window_width) {
        current_window_width = config.window_width;
        current_window_height = config.window_height;
    }
    if (root.width == current_window_width)
        if (root.height == current_window_height)
            resize_window = true;

    config.display_ratio *= ratio;

    return resize_window;
}
