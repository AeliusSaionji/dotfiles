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

# Behavior and syntax of xss-lock combined with xset:
## xset s [seconds before notifier runs] [seconds before systemctl suspend]
## The 2nd arg starts counting AFTER the 1st arg,
## eg. `xset s 2 5` would put the system to sleep in 7 seconds.
if [ $chassis = "desktop" ]; then
	xset s 3540 60 & # Timeout 1 hour
	#xset dpms 3602 3602 3602 & # DPMS timeout. Allow 2s past screensaver[+cycle] timeout (if using cycle with xss-lock) for slock to fade in (compton related?)
else
	xset s 270 30 & # Timeout 5 minutes
	#xset dpms 302 302 302 & # DPMS timeout. Allow 2s past screensaver[+cycle] timeout (if using cycle with xss-lock) for slock to fade in (compton related?)
fi

# Startup processes
pactl upload-sample /usr/share/sounds/freedesktop/stereo/bell.oga x11-bell && pactl load-module module-x11-bell sample=x11-bell display=$DISPLAY & # X11 Bell Noise
systemctl --user start x11.target & # Tell services X11 has been started

# Run slock on screensaver/monitor off/laptop lid close
xss-lock -n ~/.local/bin/suspend-countdown.sh -l -- slock &

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
