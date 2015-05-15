#!/bin/sh
xbacklight -dec 10
BRFILE=/sys/class/backlight/intel_backlight/brightness
BRMAXFILE=/sys/class/backlight/intel_backlight/max_brightness
echo `cat $BRFILE` `cat $BRMAXFILE` | awk 'END{print int($1/$2*100)}'

