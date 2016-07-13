#!/bin/bash 

export ROOT=$(dirname "$0")
export ROOT=`realpath "$ROOT"`

#dependencies
cd ~/git
git clone https://github.com/rbn42/qmltermwidget.git
cd ~/git/qmltermwidget
git checkout qmlterm
mkdir build
cd build
qmake ..
make

cd ~/git
git clone https://github.com/rbn42/QMLProcess.git
cd ~/git/QMLProcess
mkdir build
cd build
qmake ..
make

#build
cd "$ROOT"
mkdir build
cd build
qmake ..
make

#test
cd "$ROOT"
export QML2_IMPORT_PATH=~/git/QMLProcess/build:~/git/qmltermwidget/build
./build/qmlterm -c ./config.sample.ini
