#!/bin/sh

# Source scripts in xinitrc.d
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Source xprofile
[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile ] && . ~/.xprofile

# Run slock on screensaver/monitor off/laptop lid close
xss-lock -n ~/.local/bin/dim-screen.sh -l -- slock & 

# Be certain no errant quitWM exists on the system. Accident == lost work!
rm ~/.cache/quitWM
# Restart WM upon exit unless quitWM exists
while true; do
	dwm >/dev/null 2>&1
	if [ -e ~/.cache/quitWM ]; then
		# Clean up quitWM
		rm ~/.cache/quitWM
		break
	fi
done
