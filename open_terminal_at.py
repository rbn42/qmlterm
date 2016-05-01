#!/usr/bin/env python
# -*- coding: UTF-8 -*-
'''
Open new terminal window at specified path. The path is extracted from the terminal title of bash or fish.
'''
import sys
import re
import os.path

import logging
logging.basicConfig(level=logging.DEBUG,
                    filename='/dev/shm/open_terminal.log',
                    filemode='a')
logging.info('start')

p = sys.argv[1]
# logging.info(p)
#patterns = 'fish\s+(.+)', 'vim\s(.+)', ':\s(.+)\$'
# for r in patterns:
#    l = re.findall(r, p)
#    if len(l) > 0:
#        break
#p = l[0].strip()
logging.info(p)
p = os.path.expanduser(p)
logging.info(p)
os.chdir(p)
logging.info('execute')
os.system('~/git/qmlterm/run.sh')
logging.info('end')
