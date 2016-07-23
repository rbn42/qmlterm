#!/bin/bash 

#fetch dependencies
git submodule update --init

#build and install dependencies
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

#build and install
mkdir build
cd build 
qmake ..
make
sudo make install
cd ..

#test
qmlterm -c ./config.sample.ini
