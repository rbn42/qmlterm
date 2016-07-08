#include <QApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtDebug>
#include <QCommandLineParser>
#include <QSettings>
#include <QQmlContext>
#include "settings.h"

int main(int argc, char *argv[])
{
    qDebug() << "Hello world!";

    QCommandLineParser parser;
    parser.setApplicationDescription("Terminal");
    parser.addHelpOption();
    parser.addVersionOption();

    parser.addOptions({
        {{"e", "excute"},
            QCoreApplication::translate("main", "Execute commands."),
            QCoreApplication::translate("main", "command")},
        {{"c", "config"},
            QCoreApplication::translate("main", "Load configuration file"),
            QCoreApplication::translate("main", "file")},
    });

    QApplication app(argc, argv);
    parser.process(app);

    Settings settings(parser.value("c"), QSettings::IniFormat);

    QString targetDir = parser.value("e");

    qDebug() << settings.value("font/family","");

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("settings", &settings);
    engine.load(QUrl(QStringLiteral("qrc:/qmlterm.qml")));

    return app.exec();
}
