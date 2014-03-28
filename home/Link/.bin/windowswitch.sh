#!/bin/bash
# Search through open programs and switch to their tag
application=$(
	# List all running programs
	 /usr/bin/lsw |\
	# Fix Virtualbox and LibreOffice
   	# sed -e 's/.*VirtualBox/foobar  virtualbox/g' -e 's/.*soffice/foobar  libreoffice/g' |\
	# Remove flash from results
	# grep -v "plugin-container" |\
	 grep -v "parcellite" |\
	 grep -v "xombrero" |\
	# Show only app-names ---- not necessary with lsw
   	# cut -d" " -f3 |\
	# Pipe to dmenu ($@ to include font settings from dwm/config.h)
	 dmenu -i -p "Switch to" "${@}" |\
	# escape () characters for xdotool
	# application=${application//'('/'\('} application=${application//')'/'\)'};
	 sed 's/(/\\(/g' | sed 's/)/\\)/g'
)
# Switch to chosen application
# case $application in
#	gimp | truecrypt)
#		xdotool search --onlyvisible -classname "$application" windowactivate &> /dev/null
#		;;
#	*)
		xdotool search --name "${application}" windowactivate 
#		;;
#esac
