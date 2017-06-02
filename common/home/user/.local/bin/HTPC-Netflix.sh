#!/bin/sh

# This script starts or stops netflix, and
# toggles the function of various buttons on the IR remote

unbind() {
> ~/.config/sxhkd/sxhkdrc <<EOF
F1
        ~/.local/bin/HTPC-Netflix.sh
EOF
}

mousekeys() {
> ~/.config/sxhkd/sxhkdrc <<EOF
F1
	~/.local/bin/HTPC-Netflix.sh
Left
	xdotool mousemove_relative -- -35 0
Right
	xdotool mousemove_relative 35 0
Up
	xdotool mousemove_relative -- 0 -35
Down
	xdotool mousemove_relative 0 35
Return
	xdotool click 1
Prior
	xdotool click 4
Next
	xdotool click 5
EOF
}

if pgrep chromium; then
	pkill chromium
	xmodmap -e "keycode 172 = XF86AudioPlay"
	unbind
else
	/usr/bin/chromium --app=https://netflix.com &
	xmodmap -e "keycode 172 = Page_Up"
	#xmodmap pause pagedown
	mousekeys
fi

systemctl --user reload sxhkd.service
