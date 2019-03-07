#!/bin/sh

# TODO
# - Move j4 to dwm config.h

case "$1" in
# dwm keybinds
	"brightdown")
		xbacklight -dec 10
		bright=$(xbacklight -get)
		notify-send -u low -t 1000 -h int:value:$bright Brightness fondler ;;
	"brightup")
		xbacklight -inc 10
		bright=$(xbacklight -get)
		notify-send -u low -t 1000 -h int:value:$bright Brightness fondler ;;
	"browser")
		xsel -co | xargs -r xdg-open ;;
	"lock")
		xset s activate && sleep 2 && xset dpms force off ;;
	"voldown")
		vol=$(amixer set Master 5%- | sed -n -e 's/.*Playback.*\[\([0-9]*\)%\].*/\1/p' | head -n 1)
		notify-send -u low -t 1000 -h int:value:$vol Volume fondler ;;
	"volup")
		vol=$(amixer set Master 5%+ | sed -n -e 's/.*Playback.*\[\([0-9]*\)%\].*/\1/p' | head -n 1)
		notify-send -u low -t 1000 -h int:value:$vol Volume fondler ;;
	"j4") # j4dmenu arguments
		j4-dmenu-desktop --dmenu="dmenu -m \"$2\" -i" \
			--usage-log=${HOME}/.cache/j4-dmenu-desktop-cache --term="st" ;;
	"maim")
		maim $HOME/$(date +%s).png ;;
esac

# wpa_cli -a fondler.sh
case "$2" in
	"CONNECTED")
		notify-send "WiFi" "connection established" ;;
	"DISCONNECTED")
		notify-send "WiFi" "connection lost" ;;
esac
