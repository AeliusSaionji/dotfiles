#!/bin/sh
# TODO 
# - figure out why using > redirect on compton.conf just produces an empty file
# - make insertion generic, don't hook around mpv rule

activeWin=$(xprop -root _NET_ACTIVE_WINDOW | sed -e 's/^.*id\s#\s//')
dasWin=$(xprop -id $activeWin | sed -e '/^WM_CLASS/!d' -e 's/^.*\,\s//' -e 's/\"/'\''/g')
if grep $dasWin /tmp/compton.conf ; then
	sed /tmp/compton.conf -e '/'$dasWin'/d' > /tmp/compt
	notify-send "Transparency Disabled" "$dasWin"
else
	sed /tmp/compton.conf -e '/class_g = '\''mpv'\''/i\\t"class_g = '$dasWin'",' > /tmp/compt
	notify-send "Transparency Enabled" "$dasWin"
fi
pkill compton
cp /tmp/compt /tmp/compton.conf
compton -b --config /tmp/compton.conf
