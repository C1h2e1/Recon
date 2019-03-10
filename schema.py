import requests
import sys
filename=sys.argv[1]
file=open(filename,'r')
for i in file.readlines():
	i=i.strip('\n')
	print("https://"+i)

