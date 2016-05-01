cd ~/git
git clone https://github.com/rbn42/qmltermwidget.git
git checkout transparent-background
cd ~/git/qmltermwidget
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
