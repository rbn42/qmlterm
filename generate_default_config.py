#!/usr/bin/env python
# -*- coding: UTF-8 -*-
import glob
import re
import configparser

output_path = '1.ini'
qmlfiles = glob.glob('*.qml')

settings = []
for path in qmlfiles:
    s = open(path).read()
    l = re.findall('settings\.value\("(.+?)",(.+?)\)', s)
    settings += l
settings.sort()

config = configparser.ConfigParser()


def parseValue(value):
    v = value
    try:
        v = eval(v)
    except:
        pass
    try:
        v = eval(v)
    except:
        pass
    try:
        v = int(v)
        return str(v)
    except:
        pass
    try:
        v = float(v)
        return str(v)
    except:
        pass
    if v in ("true", "false"):
        return v
    return '"%s"' % v


for key, value in settings:
    k1, k2 = key.split('/')
    if k1 not in config:
        config.add_section(k1)
    value = parseValue(value)
    config[k1][k2] = value

with open(output_path, 'w') as configfile:
    config.write(configfile)
