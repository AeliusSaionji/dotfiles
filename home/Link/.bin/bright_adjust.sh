#!/bin/sh
xbacklight -$1 10
BRFILE=/sys/class/backlight/acpi_video0/brightness
BRMAXFILE=/sys/class/backlight/acpi_video0/max_brightness
bright=$(echo `cat $BRFILE` `cat $BRMAXFILE` | awk 'END{print int($1/$2*100)}')
#twmnc -c "lum [$bright]" --id 99
notify-send -t 0 "lum [$bright]"
