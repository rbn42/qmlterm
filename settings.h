#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QSettings>
class Settings : public QSettings

{
  Q_OBJECT
public:
  explicit Settings(QString path,QSettings::Format format);
  Q_INVOKABLE void setValue(const QString & key, const QVariant & value);
  Q_INVOKABLE QVariant value(const QString &key, const QVariant &defaultValue = QVariant()) const;

signals:

public slots:

private:
  QSettings settings_;
};

#endif // SETTINGS_H


