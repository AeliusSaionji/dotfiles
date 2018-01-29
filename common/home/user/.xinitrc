#!/bin/sh

# Source scripts in xinitrc.d
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Appskey = MOD4
xmodmap -e "keycode 135 = Super_L"

# Get the hostname and chassis
read -r host chassis << EOF
	$(hostnamectl status | awk '{ORS=" "} /Chassis:/ {print $2} /Static hostname:/ {print $3}')
EOF

if [ $host = "Saya" ]; then
	# Power button is Insert
	xmodmap -e "keycode 124 = Insert"
	### REMINDER! LEAVE AT LEAST ONE Fkey SO YOU CAN GET TO THE TTY ###
		# These keybindings are isolated within X, so all TTYs are still reachable.
	# Rebind F1 and F2 to PgUP and PgDown
		# not good enough for dvtm
	xmodmap -e "keycode 67 = Page_Up"
	xmodmap -e "keycode 68 = Page_Down"
	# Rebind F6-F10 to work as expected
	xmodmap -e "keycode 72 = XF86MonBrightnessDown"
	xmodmap -e "keycode 73 = XF86MonBrightnessUp"
	xmodmap -e "keycode 74 = XF86AudioMute"
	xmodmap -e "keycode 75 = XF86AudioLowerVolume"
	xmodmap -e "keycode 76 = XF86AudioRaiseVolume"
elif [ $host = "GIR" ]; then
	# Rotate button keysym
	xmodmap -e "keycode 161 = XF86Display"
elif [ $host = "Talim" ]; then
	# Rotate button keysym
	xmodmap -e "keycode 161 = XF86Display"
elif [ $host = "BOOK" ]; then
	# Alt_R = MOD4
	xmodmap -e "remove mod1 = Alt_R"
	xmodmap -e "add mod4 = Alt_R"
	# Appskey = Control_R
	xmodmap -e "keycode 135 = Control_R"
	xmodmap -e "add control = Control_R"
fi

if [ $chassis = "desktop" ]; then
	xset s off off # Disable screensaver
	xset dpms 3602 3602 3602 & # Monitor timeout. Default is 600 (10 minutes). Allow 2s past screensaver[+cycle] timeout (if using cycle with xss-lock) for slock to fade in (compton related?)
else
	xset s 300 300 & # Screensaver/cycle timeout. Defaut is 600 600 (10 minutes)
	xset dpms 602 602 602 & # Monitor timeout. Default is 600 (10 minutes). Allow 2s past screensaver[+cycle] timeout (if using cycle with xss-lock) for slock to fade in (compton related?)
fi

# Startup processes
pactl upload-sample /usr/share/sounds/freedesktop/stereo/bell.oga x11-bell && pactl load-module module-x11-bell sample=x11-bell display=$DISPLAY & # X11 Bell Noise
systemctl --user start x11.target & # Tell services X11 has been started
xss-lock -n ~/.local/bin/dim-screen.sh -l -- slock & # Run slock on screensaver/monitor off/laptop lid close

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
