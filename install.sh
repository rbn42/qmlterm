#!/bin/bash 

#fetch dependencies
git submodule update --init

#build dependencies
mkdir ./qmltermwidget/build
cd ./qmltermwidget/build
qmake ..
make
sudo make install
cd ../..

mkdir ./QMLProcess/build
cd ./QMLProcess/build
qmake ..
make
sudo make install
cd ../..

#build
mkdir build
cd build 
qmake ..
make
sudo make install
cd ..

#test
qmlterm -c ./config.sample.ini
