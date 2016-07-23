TEMPLATE = app

QT += qml quick widgets
TARGET=qmlterm
CONFIG += c++11

HEADERS += settings.h
SOURCES += main.cpp settings.cpp

RESOURCES += qml.qrc

cpscript.files =$$PWD/select_from_screen.sh 
#$$PWD/open_terminal.py

cpscript.path =$$OUT_PWD
COPIES += cpscript

# Additional import path used to resolve QML modules in Qt Creator\'s code model
QML_IMPORT_PATH =

# Default rules for deployment.
#include(deployment.pri)

#########################################
##              INTALLS
#########################################
target.path += /usr/bin/
INSTALLS += target
