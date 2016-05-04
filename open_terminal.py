#!/usr/bin/env python
# -*- coding: UTF-8 -*-
'''
Open new terminal window at specified path. The path is extracted from the terminal title of bash or fish.
'''
import sys
import os.path
import logging
logging.basicConfig(level=logging.DEBUG,
                    filename='/run/shm/open_terminal.log',
                    filemode='a')
logging.info('start')
logging.info(sys.argv)

terminal, path = sys.argv[1:]
if len(path) > 1:
    os.chdir(path)
os.system(terminal + ' &')
