#!/bin/sh
BLFILE=/sys/class/power_supply/BAT0/charge_now
BLMAXFILE=/sys/class/power_supply/BAT0/charge_full
echo `cat $BLFILE` `cat $BLMAXFILE` | awk 'END{print int($1/$2*100)}'
