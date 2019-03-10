#!/bin/bash
file_lines=$(cat $1)

for line in $file_lines
do
       sudo python linkfinder.py -i `echo $line` -o $(echo `pwd`)"/"$(echo `echo "$line"` | md5sum | sed -e 's/^\(.\{32\}\).*/\1/')".html" &>/dev/null

done

