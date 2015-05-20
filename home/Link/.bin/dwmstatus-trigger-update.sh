#!/bin/sh
# Power/Battery Status
if [[ "$( cat /sys/class/power_supply/AC/online )" -eq "1" || "$( cat /sys/class/power_supply/ACAD/online )" -eq "1" ]]; then
        POWERSOURCE="+";
else
        POWERSOURCE="-";
fi;
BATTERYLEVEL=$(( `cat /sys/class/power_supply/BAT0/charge_now` * 100 / `cat /sys/class/power_supply/BAT0/charge_full` ));

# Volume Level
#VOLUME=$( amixer sget Master | awk -vORS=' ' '/Mono:/ {print($6$4)}' );

# Network
NETPROFILE=$(netctl list | sed -e '/\*/!d' -e 's/^\* //')

# Date and Time
CLOCK=$( date '+%H:%M' );

# Overall output command
#DWM_STATUS="$NETPROFILE | [$POWERSOURCE][$BATTERYLEVEL] | $VOLUME| $CLOCK";
DWM_STATUS="$NETPROFILE | [$POWERSOURCE][$BATTERYLEVEL] | $CLOCK";
xsetroot -name "$DWM_STATUS";
