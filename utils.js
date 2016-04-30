function url2path(url){
    var prefix='file://';
    return url.substring(prefix.length);
}

function subhome(home,path){
    return path;
}
