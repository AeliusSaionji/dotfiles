# Power/Battery Status
if [ "$( cat /sys/class/power_supply/AC/online )" -eq "1" ]; then
        POWERSOURCE="AC";
else
        POWERSOURCE="BATT";
fi;
BATTERYLEVEL=$(( `cat /sys/class/power_supply/BAT0/charge_now` * 100 / `cat /sys/class/power_supply/BAT0/charge_full` ));

# Volume Level
#VOLUME=$( amixer sget Master | awk -vORS=' ' '/Mono:/ {print($6$4)}' );

# Network
NETPROFILE=$(netctl list | sed -e '/\*/!d' -e 's/\* //')

# Date and Time
CLOCK=$( date '+%H:%M' );

# Overall output command
#DWM_STATUS="[$POWERSOURCE][$BATTERYLEVEL] | $VOLUME| $NETPROFILE | $CLOCK";
DWM_STATUS="[$POWERSOURCE][$BATTERYLEVEL] | $NETPROFILE | $CLOCK";
xsetroot -name "$DWM_STATUS";
