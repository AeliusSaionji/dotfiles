#!/bin/sh
user=`whoami`
pids=`pgrep -u $user dunst`

for pid in $pids; do
        # find DBUS session bus for this session
        DBUS_SESSION_BUS_ADDRESS=`grep -z DBUS_SESSION_BUS_ADDRESS \
                /proc/$pid/environ | sed -e 's/DBUS_SESSION_BUS_ADDRESS=//'`
done

case "$1" in
	"low")
	        DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
			notify-send -u normal "low battery" ;;
	"critical")
	        DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
			notify-send -u critical "low battery" "find power soon!" ;;
	"sleep")
	        DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
			notify-send -u critical "suspend imminent" "the system is going down in 5 seconds!" \
			&& sleep 5 && systemctl suspend ;;
	"hibernate")
		echo "not implemented" ;;
esac
