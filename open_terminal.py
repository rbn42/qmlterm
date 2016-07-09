#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# Open new terminal window at specified path.
import sys
import os.path
import logging
logging.basicConfig(level=logging.DEBUG,
                    filename='/tmp/qmlterm_open_terminal.log',
                    filemode='a')
logging.info(sys.argv)

terminal, configuration, path = sys.argv[1:]
if len(path) > 1:
    os.chdir(path)
if len(configuration) > 1:
    terminal = terminal + " -c " + configuration
logging.info(terminal)
os.system(terminal + ' &')
