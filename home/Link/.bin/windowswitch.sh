#!/bin/bash
# Search through open programs and switch to their tag
application=$(
	# List all running programs
# switch to this xwininfo -tree -root
	 /usr/bin/xlsclients |\
	# Remove flash from results
	# grep -v "plugin-container" |\
	 tr -d "Saya " |\
	# Pipe to dmenu ($@ to include font settings from dwm/config.h)
	 dmenu -l 30 -i -p "Switch to" "${@}"
	# escape () characters for xdotool
	# application=${application//'('/'\('} application=${application//')'/'\)'};
	# sed 's/(/\\(/g' | sed 's/)/\\)/g'
)
# Switch to chosen application
# case $application in
#	gimp | truecrypt)
#		xdotool search --onlyvisible -classname "$application" windowactivate &> /dev/null
#		;;
#	*)
		xdotool search --class "${application}" windowactivate 
#		;;
#esac
