#!/bin/bash 

sudo apt-get install build-essential qmlscene qt5-qmake qt5-default qtdeclarative5-dev qtdeclarative5-controls-plugin qtdeclarative5-qtquick2-plugin libqt5qml-graphicaleffects qtdeclarative5-dialogs-plugin qtdeclarative5-localstorage-plugin qtdeclarative5-window-plugin -y

cd ~/git
git clone https://github.com/rbn42/qmltermwidget.git
cd ~/git/qmltermwidget
git checkout transparent-background
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
cd ..
cp ./qmldir ./build/QMLProcess
