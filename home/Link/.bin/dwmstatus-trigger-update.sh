#!/bin/sh

# Power Status
if [[ "$( cat /sys/class/power_supply/AC/online )" -eq "1" || "$( cat /sys/class/power_supply/ACAD/online )" -eq "1" ]]; then
        POWERSOURCE="+";
else
        POWERSOURCE="-";
fi;

# Battery Status
BATTERYLEVEL=$(( `cat /sys/class/power_supply/BAT0/charge_now` * 100 / `cat /sys/class/power_supply/BAT0/charge_full` ));
if [ -d /sys/class/power_supply/BAT1 ]; then
	SPAREBATTERYLEVEL=$(( `cat /sys/class/power_supply/BAT1/charge_now` * 100 / `cat /sys/class/power_supply/BAT1/charge_full` ));
fi;

# Network Status
NETPROFILE=$(netctl list | sed -e '/\*/!d' -e 's/^\* //');

# Date and Time
CLOCK=$( date '+%H:%M' );

# Overall output command
DWM_STATUS="$NETPROFILE | [$SPAREBATTERYLEVEL][$POWERSOURCE][$BATTERYLEVEL] | $CLOCK";
xsetroot -name "$DWM_STATUS";
