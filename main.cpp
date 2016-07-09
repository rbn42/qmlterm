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

    QString path_terminal(realpath(argv[0],NULL));

    QCommandLineParser parser;
    parser.setApplicationDescription("Terminal");
    parser.addHelpOption();
    parser.addVersionOption();

    parser.addOptions({
        {{"e", "command"},
            QCoreApplication::translate("main", "Execute commands."),
            QCoreApplication::translate("main", "command")},
        {{"c", "config"},
            QCoreApplication::translate("main", "Load configuration file"),
            QCoreApplication::translate("main", "file")},
    });

    QApplication app(argc, argv);
    parser.process(app);
    Settings settings(parser.value("c"), QSettings::IniFormat);

    QString command= parser.value("e");
//    qDebug() << settings.value("font/family","");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("settings", &settings);
    engine.rootContext()->setContextProperty("command", command);
    engine.rootContext()->setContextProperty("path_terminal", path_terminal);
    engine.rootContext()->setContextProperty("path_configuration",parser.value("c") );

    engine.load(QUrl(QStringLiteral("qrc:/qmlterm.qml")));

    return app.exec();
}
