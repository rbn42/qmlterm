#!/bin/bash 
qmlscene \
    "$@" \
    -I ~/git/qmltermwidget/build \
    -I ~/git/QMLProcess/build \
    ~/git/qmlterm/qmlterm.qml \
    --transparent \

    #-- "$@"
