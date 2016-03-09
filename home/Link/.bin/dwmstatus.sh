#!/bin/sh

while true; do
	# Power Status
	if [ -d /sys/class/power_supply/* ]; then
		if [ "$(cat /sys/class/power_supply/*/online)" -eq "1" ]; then
			POWERSOURCE="+"
		else
			POWERSOURCE="-"
		fi
		# Battery Status
		BATTERYLEVEL=$(cat /sys/class/power_supply/BAT0/capacity)
		POWER="| [$POWERSOURCE] $BATTERYLEVEL"
		if [ -d /sys/class/power_supply/BAT1 ]; then
			SPAREBATTERYLEVEL=$(cat /sys/class/power_supply/BAT1/capacity)
			POWER="$SPAREBATTERYLEVEL [$POWERSOURCE] $BATTERYLEVEL"
		fi
	fi
	# Network Status
	NET=$(wpa_cli status | sed -e '/^wpa_state=/!d' -e 's/^wpa_state=//')
	if [ "$NET" = "COMPLETED" ]; then
		NETPROFILE=$(wpa_cli status | sed -e '/^ssid=/!d' -e 's/^ssid=//')
		SIGNALSTR=$(wpa_cli signal_poll | awk -F '=' '/^RSSI=/ {printf $2 "dBm/"} /^LINKSPEED=/ {printf $2 "mbps"}')
		NET="$NETPROFILE $SIGNALSTR"
	elif [ -z "$NET" ]; then
		DEV=$(ip link | sed -e '/state UP/!d' | awk -F ': ' '{print $2}')
		if [ -z "$DEV" ]; then
			NET="offline"
		else
			NET=$(ip addr | awk "/$DEV\$/" | awk '{print $7":",$2}')
		fi
	fi

	# Date and Time
	CLOCK=$( date '+%H:%M' )

	# Load
	LOAD=$(cat /proc/loadavg | awk '{print $1, $2, $3}')

	# Overall output command
	xsetroot -name "$LOAD | $NET $POWER| $CLOCK"
	sleep 10
done
