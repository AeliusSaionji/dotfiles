#!/bin/sh
user=$(whoami)
pids=$(pgrep -u $user dunst)

for pid in $pids; do
        # find DBUS session bus for this session
        DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS \
                /proc/$pid/environ | sed -e 's/DBUS_SESSION_BUS_ADDRESS=//')
done

DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
	notify-send "${LDM_MOUNTPOINT} ${LDM_ACTION}ed"
