function url2path(url) {
    var prefix = 'file://';
    return url.substring(prefix.length);
}

function subhome(home, path) {
    return path;
}

var current_window_width
var current_window_height

function resize(ratio, config, window_) {
    var resize_window = false;
    if (!current_window_width) {
        current_window_width = config.window_width;
        current_window_height = config.window_height;
    }
    if (window_.width == current_window_width)
        if (window_.height == current_window_height)
            resize_window = true;

    config.display_ratio *= ratio;

    if (resize_window) {
        window_.width = config.window_width * config.display_ratio;
        window_.height = config.window_height * config.display_ratio;
        current_window_width = window_.width;
        current_window_height = window_.height;
    }

    return resize_window;
}
