#!/bin/bash 

sudo apt-get install build-essential qmlscene qt5-qmake qt5-default qtdeclarative5-dev qtdeclarative5-controls-plugin qtdeclarative5-qtquick2-plugin libqt5qml-graphicaleffects qtdeclarative5-dialogs-plugin qtdeclarative5-localstorage-plugin qtdeclarative5-window-plugin -y
#arch
#sudo pacman -S qt5-base qt5-declarative qt5-quickcontrols qt5-graphicaleffects

cd ~/git
git clone https://github.com/rbn42/qmltermwidget.git
cd ~/git/qmltermwidget
#git checkout transparent-background
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
cd ..
cp ./qmldir ./build/QMLProcess
