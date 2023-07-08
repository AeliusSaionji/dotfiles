#!/bin/sh

# TODO
# - Move j4 to dwm config.h
#bar() { seq -s '#' "$1" | tr '[0-9]' '#'; }

nsh() { notify-send -u low -t 1000 -h "int:value:$1" "$2" fondler; }
vol() { amixer set Master "5%$1" | sed -n -e 's/.*Playback.*\[\([0-9]*\)%\].*/\1/p' | head -n 1; }
brt() { xbacklight "$1" 10; xbacklight -get; }

case "$1" in
# dwm keybinds
	"brightdown")
		nsh "$(brt -dec)" Brightness ;;
	"brightup")
		nsh "$(brt -inc)" Brightness ;;
	"browser")
		xclip -o -selection primary | xargs -r xdg-open ;;
	"voldown")
		nsh "$(vol -)" Volume  ;;
	"volup")
		nsh "$(vol +)" Volume ;;
	"j4") # j4dmenu arguments
		j4-dmenu-desktop --dmenu="dmenu -m \"$2\" -i" \
			--usage-log=${HOME}/.cache/j4-dmenu-desktop-cache --term="st" ;;
	"maim")
		maim -s | xclip -selection clipboard -t image/png ;;
esac

# wpa_cli -a fondler.sh
case "$2" in
	"CONNECTED")
		notify-send "WiFi" "connection established" ;;
	"DISCONNECTED")
		notify-send "WiFi" "connection lost" ;;
esac
