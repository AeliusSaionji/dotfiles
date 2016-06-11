#!/bin/sh

#TODO
# - implement status/other, pipe output to dmenu
# - elevate with sudo askpass + enable --system
# - find a way to indicate failed/running state within the initial list.
#	might require parsing output of systemctl,
#	printing to dmenu like: unit.service -- FAILED
#	re-parsing what dmenu returns

action=$(echo -e 'start\nstop\nrestart' | dmenu -fn inconsolata:size=8)
# List user units
unit=$(ls .config/systemd/user/ --ignore=\*.wants | dmenu -l 10 -fn inconsolata:size=8)

systemctl --user $action $unit
