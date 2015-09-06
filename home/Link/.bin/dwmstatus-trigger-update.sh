#!/bin/sh

# Power Status
if [ "$(cat /sys/class/power_supply/AC/online)" -eq "1" ]; then
        POWERSOURCE="+";
else
        POWERSOURCE="-";
fi;

# Battery Status
BATTERYLEVEL=[$(cat /sys/class/power_supply/BAT0/capacity)];
if [ -d /sys/class/power_supply/BAT1 ]; then
	SPAREBATTERYLEVEL=[$(cat /sys/class/power_supply/BAT1/capacity)];
fi;

# Network Status
NETPROFILE="$(netctl list | sed -e '/\*/!d' -e 's/^\* //') |";

# Date and Time
CLOCK=$( date '+%H:%M' );

# Load
LOAD="`cat /proc/loadavg | awk '{print $1, $2, $3}'`";

# Overall output command
xsetroot -name "$LOAD | $NETPROFILE $SPAREBATTERYLEVEL[$POWERSOURCE]$BATTERYLEVEL | $CLOCK";
