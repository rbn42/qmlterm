#!/usr/bin/env python
# -*- coding: UTF-8 -*-
import glob
import re
import configparser
import sys

output_path = sys.argv[1]
qmlfiles = glob.glob('*.qml')

settings = []
for path in qmlfiles:
    s = open(path).read()
    l = re.findall('settings\.v(alue\(.+?\))', s)
    settings += l

# parse to python
alue = lambda a, b: (a, b)
true = "true"
false = "false"
null = "null"
settings = [eval(s) for s in settings]
settings.sort()

config = configparser.ConfigParser()
config.optionxform = str


def parseValue(v):
    if v in ("true", "false"):
        return v
    if type(v) == str:
        if ',' in v:
            return '"%s"' % v
        else:
            return v
    return str(v)

for key, value in settings:
    k1, k2 = key.split('/')
    if k1 not in config:
        config.add_section(k1)
    value = parseValue(value)
    config[k1][k2] = value

config.add_section('env')
config["env"]["PASS_THIS_VALUE"] = "INTO_SESSION_ENVIRONMENT"

with open(output_path, 'w') as configfile:
    config.write(configfile)
