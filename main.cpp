#include <QApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtDebug>
#include <QCommandLineParser>
#include <QSettings>
#include <QQmlContext>
#include "settings.h"
#include <stdlib.h>

int main(int argc, char *argv[])
{
    QString path_terminal(realpath(argv[0], NULL));

    QCommandLineParser parser;
    parser.setApplicationDescription("Terminal");
    parser.addHelpOption();
    parser.addVersionOption();

    parser.addOptions(
    {
        {   {"e", "command"},
            QCoreApplication::translate("main", "Execute commands."),
            QCoreApplication::translate("main", "command")
        },
        {   {"c", "config"},
            QCoreApplication::translate("main", "Load configuration file"),
            QCoreApplication::translate("main", "file")
        },
    });

    QApplication app(argc, argv);
    parser.process(app);
    QSettings qsettings(parser.value("c"), QSettings::IniFormat);
    Settings settings(parser.value("c"), QSettings::IniFormat);

    QString command = parser.value("e");

    qsettings.beginGroup("env");
    QStringList keys = qsettings.childKeys();
    //qDebug() << keys;
    foreach (const QString &key, keys)
    {
        QString value = qsettings.value(key).toString();
        setenv(key.toLatin1().data(), value.toLatin1().data(),1);
    }

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("settings", &settings);
    engine.rootContext()->setContextProperty("command", command);
    engine.rootContext()->setContextProperty("path_terminal", path_terminal);
    engine.rootContext()->setContextProperty("path_configuration", parser.value("c") );

    engine.load(QUrl(QStringLiteral("qrc:/qmlterm.qml")));

    return app.exec();
}

const char* convert_qstr(const QString &str)
{
    QString str1 = "Test";
    QByteArray ba = str1.toLatin1();
    const char *c_str2 = ba.data();
    return c_str2;
}
