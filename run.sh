#!/bin/bash 

export QML2_IMPORT_PATH=~/git/QMLProcess/build:~/git/qmltermwidget/build

export QML=$(dirname "$0")/qmlterm.qml

cp ~/.qmltermrc $(dirname "$0")/Configuration.qml

qmlscene "$@" $QML

#    -I ~/git/qmltermwidget/build \
#    -I ~/git/QMLProcess/build \

#    --transparent
