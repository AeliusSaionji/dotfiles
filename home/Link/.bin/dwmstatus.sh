DWM_REFRESH_INT="1m"
while true; do

# Power/Battery Status
if [ "$( cat /sys/class/power_supply/AC/online )" -eq "1" ]; then
        DWM_BATTERY="AC";
        DWM_RENEW_INT=3;
else
        DWM_BATTERY=$(( `cat /sys/class/power_supply/BAT0/charge_now` * 100 / `cat /sys/class/power_supply/BAT0/charge_full` ));
        DWM_RENEW_INT=30;
fi;

# Volume Level
DWM_VOL=$( amixer sget Master | awk -vORS=' ' '/Mono:/ {print($6$4)}' );

# Date and Time
DWM_CLOCK=$( date '+%H:%M' );

# Overall output command
DWM_STATUS="Batt: [$DWM_BATTERY] | Vol: $DWM_VOL| $DWM_CLOCK";
xsetroot -name "$DWM_STATUS";
sleep $DWM_REFRESH_INT;

done &
