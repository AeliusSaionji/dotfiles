#!/bin/sh

# This script is meant to be run by xss-lock as a "notifier",
# to be used with xset s [timeout] [cycle].

# Behavior and syntax of xss-lock combined with xset:
## xset s [seconds before notifier runs] [seconds before systemctl suspend]
## The 2nd arg starts counting AFTER the 1st arg,
## eg. `xset s 2 5` would run this script in 2s and suspend the system in 7s.
## xss-lock will kill this script upon any user activity.

# Beware! Race condition!
## This script is killed when [cycle] is reached, so the countdown loop
## must complete before then, lest the following statements never be executed.
## [cycle] must be greater than 5 to prevent the race condition.

# grep -l returns 1 if nothing is found; the test statement is TRUE if audio is playing.
if [ $(grep -lr 'RUNNING' /proc/asound) ]; then
	# Reset timer to avoid [cycle], which would lock the screen.
	# This reset will kill this script.
	xset s reset
fi

# Obtain the configured [cycle] time.
cycle=$(xset q | awk '/timeout/ {print $4}')
# Offset [cycle] so we can rig the race (condition).
start=$(($cycle - 5))

# Countdown with visual notification.
for countdown in $(seq $start -1 1); do
	notify-send -u critical -t 1500 -h int:value:$countdown 'Suspending in:' countdown
	sleep 1
done

# Suspend the system.
systemctl suspend
