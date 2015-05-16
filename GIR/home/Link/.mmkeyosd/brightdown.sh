#!/bin/sh
xbacklight -dec 10
BRFILE=/sys/class/backlight/acpi_video0/brightness
BRMAXFILE=/sys/class/backlight/acpi_video0/max_brightness
echo `cat $BRFILE` `cat $BRMAXFILE` | awk 'END{print int($1/$2*100)}'

