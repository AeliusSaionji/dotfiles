#!/bin/sh

case "$1" in
# dwm keybinds
	"brightdown")
		xbacklight -dec 10
		bright=$(xbacklight -get)
		notify-send -u low -t 1 -h int:value:$bright Brightness fondler ;;
	"brightup")
		xbacklight -inc 10
		bright=$(xbacklight -get)
		notify-send -u low -t 1 -h int:value:$bright Brightness fondler ;;
	"browser")
		xsel -co | xargs -r xdg-open ;;
	"dunsttoggle")
		if [ -f /tmp/dwmstatus.d/dunstpaused ]; then
			killall -SIGUSR2 dunst && rm /tmp/dwmstatus.d/dunstpaused # resume
			systemctl --user restart dwmstatus.service
		else
			mkdir -p /tmp/dwmstatus.d
			killall -SIGUSR1 dunst && echo "dunst paused!" > /tmp/dwmstatus.d/dunstpaused # pause
			systemctl --user restart dwmstatus.service
		fi ;;
	"lock")
		xset s activate && sleep 2 && xset dpms force off ;;
	"rotate")
		deviceName=$(xsetwacom --list devices | sed -e '/touch/!d' -e 's/\s\w\+\s\+id.*$//')
		if [ -z $deviceName ]; then
			notify-send "Touch device not found" "you're probably using libinput"
		fi
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
		fi ;;
	"dwgrep")
		# Window switcher, displays all windows
		wmctrl -l | sed -e 's/^0x[0-9a-f]\+[0-9 ]\+[^ ]\+\s//' | dmenu -p "Global window switch" -i -l 10 | xargs wmctrl -a ;;
	"dwtaggrep")
		# Window switcher, only displays currently visible windows
		wmctrl -lG | sed -e '/0 0/!d' -e 's/^0x[0-9a-f]\+[0-9 ]\+[^ ]\+\s//' | dmenu -p "Visible window switch" -i -l 10 | xargs wmctrl -a ;;
	"voldown")
		vol=$(amixer set Master 5%- | sed -n -e 's/.*Playback.*\[\([0-9]*\)%\].*/\1/p' | head -n 1)
		notify-send -u low -t 1 -h int:value:$vol Volume fondler ;;
	"volup")
		vol=$(amixer set Master 5%+ | sed -n -e 's/.*Playback.*\[\([0-9]*\)%\].*/\1/p' | head -n 1)
		notify-send -u low -t 1 -h int:value:$vol Volume fondler ;;

	"-m") # j4dmenu arguments
		dmenuArgs=$(echo "$@" | sed -e 's/#/\\#/g')
		j4-dmenu-desktop --dmenu="/usr/bin/dmenu $dmenuArgs" --usage-log=${HOME}/.cache/j4-dmenu-desktop-cache --term="st -e" ;;
# NERV keybinds
	"foobnext")
			wine ~/.foobar2000/foobar2000.exe /next ;;
	"foobplay")
			wine ~/.foobar2000/foobar2000.exe /playpause ;;
	"foobprev")
			wine ~/.foobar2000/foobar2000.exe /prev ;;
esac

# wpa_cli -a fondler.sh
case "$2" in
	"CONNECTED")
		notify-send "WiFi" "connection established" ;;
	"DISCONNECTED")
		notify-send "WiFi" "connection lost" ;;
esac
