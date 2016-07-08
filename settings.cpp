#include "settings.h"

Settings::Settings(QString path,QSettings::Format format) :
  QSettings(path,format) {
}

void Settings::setValue(const QString &key, const QVariant &value) {
  QSettings::setValue(key, value);
}

QVariant Settings::value(const QString &key, const QVariant &defaultValue) const {
  return QSettings::value(key, defaultValue);
}
