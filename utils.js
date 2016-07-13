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
