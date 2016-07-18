#!/bin/bash 

mkdir build
cd build

#build dependencies
qmake ../qmltermwidget
make
qmake ../QMLProcess
make

#build
qmake ..
make

#test
cd ..
./build/qmlterm -c ./config.sample.ini
