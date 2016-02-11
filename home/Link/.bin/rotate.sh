#!/bin/sh
deviceName=$(xsetwacom --list devices | sed -e '/touch/!d' -e 's/\s\w\+\s\+id.*$//')
# Needs to be tested in a multi monitor setup
displayName=$(xrandr | sed -e '2!d' -e 's/\sconnected.*$//')
orientation=$(xrandr | sed -e '/\sconnected/!d' -e 's/\w\+\sconnected\s[0-9]\+x[0-9]\++[0-9]\++[0-9]\+\s//' -e 's/(normal.*$//' -e '/^$/d')
if [ -z $orientation ]; then
	xrandr --output $displayName --rotate right
	xsetwacom --set "$deviceName stylus" Rotate cw
	xsetwacom --set "$deviceName eraser" Rotate cw
	xsetwacom --set "$deviceName touch"  Rotate cw
	echo right
else
	xrandr --output $displayName --rotate normal
	xsetwacom --set "$deviceName stylus" Rotate none
	xsetwacom --set "$deviceName eraser" Rotate none
	xsetwacom --set "$deviceName touch"  Rotate none
	echo normal
fi
