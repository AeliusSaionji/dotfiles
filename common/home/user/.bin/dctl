#!/bin/sh

#TODO
# - implement status/enable/etc, pipe output to dmenu
# - option to ask for services or action first
#	asking for service first allows us to print its status seamlessly
# - find a way to indicate failed/running state within the initial list.
# - libnotify?

export SUDO_ASKPASS=~/.bin/askpass.sh
font="inconsolata:size=8"
action=$(echo -e 'start\nstop\nrestart\ndaemon reload\n--user start\n--user stop\n--user restart\n--user daemon reload' | dmenu -fn $font)

# if action is status
#if [ "$action" = '--user status' -o "$action" = 'status' ]; then
	# combine output of both --user and --system
# if action contains '--user'
if [ -z $(echo $action | sed -e '/--user/d') ]; then
	# List --user units
	unit=$(systemctl --user list-unit-files --no-pager \
		| grep -P 'enabled|enabled-runtime|linked|linked-runtime|masked|masked-runtime|static|indirect|disabled|generated|transient|bad' \
		| dmenu -fn $font -l 20 | grep -o -P '^.*\.\w+')
	systemctl $action $unit
else # action for system
	# List units
	unit=$(systemctl list-unit-files --no-pager \
		| grep -P 'enabled|enabled-runtime|linked|linked-runtime|masked|masked-runtime|static|indirect|disabled|generated|transient|bad' \
		| dmenu -fn $font -l 20 | grep -o -P '^.*\.\w+')
	sudo -A systemctl $action $unit
fi

