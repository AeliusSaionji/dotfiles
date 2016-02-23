#!/bin/sh
user=$(whoami)
pids=$(pgrep -u $user dunst)

for pid in $pids; do
        # find DBUS session bus for this session
        DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS \
		/proc/$pid/environ | sed -e 's/DBUS_SESSION_BUS_ADDRESS=//')
done

case "$1" in
# udev 99-lowbat.rules
	"low")
		DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
			notify-send -u normal "Low Battery" ;;
	"critical")
		DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
			notify-send -u critical "Low Battery" "Find power soon!" ;;
	"sleep")
		DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
			notify-send -u critical "Suspend Imminent" "The system is going down in under two minutes!" ;;
	"hibernate")
		echo "not implemented" ;;
# dwm keybinds
	"brightdown")
		xbacklight -dec 10
		bright=$(xbacklight -get)
		DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
			notify-send -t 1 -h int:value:$bright Brightness fondler ;;
	"brightup")
		xbacklight -inc 10
		bright=$(xbacklight -get)
		DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
			notify-send -t 1 -h int:value:$bright Brightness fondler ;;
	"browser")
		xsel -co | xargs -r qutebrowser ;;
	"lock")
		xset s activate && sleep 2 && xset dpms force off ;;
	"rotate")
		deviceName=$(xsetwacom --list devices | sed -e '/touch/!d' -e 's/\s\w\+\s\+id.*$//')
		if [ -z $deviceName ]; then
			DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
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
	"voldown")
		vol=$(amixer set Master 5%- | sed -n -e 's/.*Playback.*\[\([0-9]*\)%\].*/\1/p' | head -n 1)
		DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
			notify-send -t 1 -h int:value:$vol Volume fondler ;;
	"volup")
		vol=$(amixer set Master 5%+ | sed -n -e 's/.*Playback.*\[\([0-9]*\)%\].*/\1/p' | head -n 1)
		DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
			notify-send -t 1 -h int:value:$vol Volume fondler ;;
	
	"-m") # j4dmenu arguments
		dmenuArgs=$(echo "$*" | sed -e 's/#/\\#/g')
		j4-dmenu-desktop --dmenu="dmenu $dmenuArgs" ;;
esac

# wpa_cli -a fondler.sh
case "$2" in
	"CONNECTED")
		DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
			notify-send "WiFi" "connection established" ;;
	"DISCONNECTED")
		DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
			notify-send "WiFi" "connection lost" ;;
esac
