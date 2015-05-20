#!/bin/sh
if (pgrep -x xombrero)
then
	xombrero -e "open $1" &
else
	xombrero "$1" &
fi
