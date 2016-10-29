#!/bin/sh
# TODO 
# - make insertion generic, don't hook around mpv rule

volatileConfig="$HOME/.cache/compton.conf"

case $1 in
	createcache)
		[ -e $volatileConfig ] || cp $HOME/.config/compton.conf $volatileConfig
		exit ;;
esac

activeWin=$(xprop -root _NET_ACTIVE_WINDOW | sed -e 's/^.*id\s#\s//')
dasWin=$(xprop -id $activeWin | sed -e '/^WM_CLASS/!d' -e 's/^.*\,\s//' -e 's/\"/'\''/g')

if grep $dasWin $volatileConfig ; then
	sed -i $volatileConfig -e '/'$dasWin'/d'
	notifymsg="Transparency Enabled"
else
	sed -i $volatileConfig -e '/class_g = '\''mpv'\''/i\\t"class_g = '$dasWin'",'
	notifymsg="Transparency Disabled"
fi
systemctl --user restart compton.service
sleep 1
notify-send "$notifymsg" "$dasWin"
