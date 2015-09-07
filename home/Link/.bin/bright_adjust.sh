#!/bin/zsh
xbacklight -$1 10
BRFILE=/sys/class/backlight/acpi_video0/brightness
BRMAXFILE=/sys/class/backlight/acpi_video0/max_brightness
bright=$(echo `cat $BRFILE` `cat $BRMAXFILE` | awk 'END{print int($1/$2*100)}')
bar=$(printf '%.0s|' {0..$((bright/2))}; printf '%.0s ' {0..$((50-$((bright/2))))})
#twmnc -c "lum [$bright]" --id 99
notify-send -t 0 "lum [$bright] [ $bar]"
