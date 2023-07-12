#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys

class my():
	def log(msg):
		with open('output.txt', 'a') as f:
			f.write(msg + '\n')
			f.close()
			return True

