#!/bin/bash 

mkdir build
cd build
qmake ..
make
cp ../*.py ./
cp ../*.sh ./

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
cd ..
cp ./qmldir ./build/QMLProcess


