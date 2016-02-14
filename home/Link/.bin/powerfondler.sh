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
			notify-send -u normal "Low Battery" ;;
	"critical")
	        DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
			notify-send -u critical "Low Battery" "Find power soon!" ;;
	"sleep")
	        DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
			notify-send -u critical "Suspend Imminent" "The system is going down in under two minutes!" ;;
	"hibernate")
		echo "not implemented" ;;
esac
