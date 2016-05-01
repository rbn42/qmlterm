#!/usr/bin/env python
# -*- coding: UTF-8 -*-
'''
Open new terminal window at specified path. The path is extracted from the terminal title of bash or fish.
'''
import sys
import os.path
terminal, path = sys.argv[1:]
os.chdir(path)
os.system(terminal)
