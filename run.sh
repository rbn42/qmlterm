#!/bin/bash 
qmlscene \
    -I ~/git/qmltermwidget/build \
    -I ~/git/QMLProcess/build \
    ~/git/qmlterm/qmlterm.qml \
    -- "$1" "$2" "$3" "$4" "$5" "$6" "$7"
#    --transparent
