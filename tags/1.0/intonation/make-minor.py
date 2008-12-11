#!/usr/bin/python
import os
import sys

filelines = open(sys.argv[1]).readlines()
out = open(sys.argv[1],"w")
for f in filelines:
	f = f.replace("dis", "ees")
	f = f.replace("ais", "bes")
	out.write(f)

