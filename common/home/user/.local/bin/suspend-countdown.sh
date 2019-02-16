#!/bin/sh

# This script is meant to be run by xss-lock as a "notifier",
# to be used with xset s [timeout] [cycle].
# Beware! Race condition!
# This script is killed when [cycle] is reached, so the countdown loop
# must complete before then, lest the following statements never be executed.

# Check if audio is playing. grep -l returns 1 if nothing is found;
# thus the test statement is TRUE if audio is playing.
while [ $(grep -lr 'RUNNING' /proc/asound) ]; do
	#notify-send -u critical 'Suspend inhibited by playing audio'
	# In this loop we indefinitely delay the below suspend, but this script is only
	# the [timeout] part of xset s [timeout] [cycle]. Input prevents screen blank.
	xdotool key F24
	sleep 10
done

# Obtain the cycle setting.
cycle=$(xset q | awk '/timeout/ {print $4}')
# Offset cycle so we can correctly structure the race condition.
start=$(($cycle - 5))

# Countdown with visual notification.
for countdown in $(seq $start -1 1); do
	notify-send -u critical -t 1500 -h int:value:$countdown 'Suspending in:' countdown
	sleep 1
done

# Suspend the system.
systemctl suspend