#!/bin/sh
# TODO - use active window instead of selecting with mouse

dasWin=$(xprop | sed -e '/^WM_CLASS/!d' -e 's/^.*\,\s//' -e 's/\"/'\''/g')
if grep $dasWin /tmp/compton.conf ; then
	sed /tmp/compton.conf -e '/'$dasWin'/d' > /tmp/compt
else
	sed /tmp/compton.conf -e '/mpv/i\\t"class_g = '$dasWin'",' > /tmp/compt
fi
pkill compton
cp /tmp/compt /tmp/compton.conf
compton -b --config /tmp/compton.conf
