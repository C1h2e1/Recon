import os
import sys

files_input=sys.argv[1]
files=open(files_input,"r")
for i in files.readlines():
	command='sudo python linkfinder.py -i'+i
	os.system(str(command))
