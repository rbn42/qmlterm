#!/bin/bash 

#cp ~/.config/qmlterm/config ~/git/qmlterm/config
cp ~/.qmltermrc ~/git/qmlterm/Configuration.qml

qmlscene \
    -I ~/git/qmltermwidget/build \
    -I ~/git/QMLProcess/build \
    ~/git/qmlterm/qmlterm.qml \
    -- "$@"
#    --transparent
