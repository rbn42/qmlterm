function url2path(url) {
    var prefix = 'file://';
    return url.substring(prefix.length);
}

function findFile(file, path_termianl) {
    var l = path_termianl.split('/');
    l[l.length - 1] = file;
    var s = l.join('/');
    return s
}

function subhome(home, path) {
    return path;
}

var current_window_width
var current_window_height

function resize(ratio, config, window_) {
    var resize_window = false;
    if (!current_window_width) {
        current_window_width = config.width;
        current_window_height = config.height;
    }
    console.log(current_window_width)
    console.log(config.window_)
    if (window_.width == current_window_width)
        if (window_.height == current_window_height)
            resize_window = true;
    console.log(window_.width)

    config.scale*=ratio;

    // Do not resize windows that have been resized manually.
    if (resize_window) {
        window_.width=config.width*config.scale;
        window_.height=config.height*config.scale;
        current_window_width = window_.width;
        current_window_height = window_.height;
    }

    return resize_window;
}
