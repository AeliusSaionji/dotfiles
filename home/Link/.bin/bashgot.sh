#!/bin/sh

# pipe the output of curl to this script
#	curl www.google.com | bashgot.sh [searchpattern] [begin]
# List URLs
if [ ! -n $1 ]; then
	grep -Po '(href\=.(//)?|src\=.(//)?)\K\S+\....(?=\")'
# First argument is searchpattern
elif [ -n $1 ]; then
	grep -Po '(href\=.(//)?|src\=.(//)?)\K\S+\....(?=\")' | grep -P $1
# Second argument passes output to curl
elif [ $2 = "begin" ]; then 
	grep -Po '(href\=.(//)?|src\=.(//)?)\K\S+\....(?=\")' | grep -P $1 | xargs -P 4 curl --remote-name-all
fi
