#!/bin/bash 

cp ~/.qmltermrc $(dirname "$0")/Configuration.qml

qmlscene \
    "$@" \
    -I ~/git/qmltermwidget/build \
    -I ~/git/QMLProcess/build \
    $(dirname "$0")/qmlterm.qml \
    --transparent \
