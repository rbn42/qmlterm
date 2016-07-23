#include "settings.h"
#include <QApplication>
#include <QCommandLineParser>
#include <QDir>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include <QtDebug>
#include <stdlib.h>

int main(int argc, char* argv[])
{

    QCommandLineParser parser;
    parser.setApplicationDescription("Terminal");
    parser.addHelpOption();
    parser.addVersionOption();

    parser.addOptions(
        {
            { { "e", "command" },
                QCoreApplication::translate("main", "Execute commands."),
                QCoreApplication::translate("main", "command") },
            { { "c", "config" },
                QCoreApplication::translate("main", "Load configuration file"),
                QCoreApplication::translate("main", "file") },
            { { "s", "size" },
                QCoreApplication::translate("main", "Terminal window size. Example: 500x300"),
                QCoreApplication::translate("main", "size") },
        });

    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    parser.process(app);

    Settings settings(parser.value("c"), QSettings::IniFormat);
    engine.rootContext()->setContextProperty("settings", &settings);
    //Terminal Window Size
    QString size = parser.value("s");
    if (size.size() > 0) {
        int w = size.split("x")[0].toInt();
        int h = size.split("x")[1].toInt();
        settings.setValue("window/width", w);
        settings.setValue("window/height", h);
    }

    //set environment variables.
    QSettings qsettings(parser.value("c"), QSettings::IniFormat);
    qsettings.beginGroup("env");
    QStringList keys = qsettings.childKeys();
    foreach (const QString& key, keys) {
        QString value = qsettings.value(key).toString();
        setenv(key.toLatin1().data(), value.toLatin1().data(), 1);
    }

    QString command = parser.value("e");
    engine.rootContext()->setContextProperty("command", command);

    qDebug() << "argv 0" << argv[0];

    QString path_terminal(realpath(argv[0], NULL));
    if (path_terminal.length() < 1)
        path_terminal=QString(argv[0]);
    qDebug() << "path_terminal" << path_terminal;

    engine.rootContext()->setContextProperty("path_terminal", path_terminal);

    engine.rootContext()->setContextProperty("path_configuration", parser.value("c"));

    engine.rootContext()->setContextProperty("current_path", QDir::currentPath());

    engine.load(QUrl(QStringLiteral("qrc:/qmlterm.qml")));

    return app.exec();
}
