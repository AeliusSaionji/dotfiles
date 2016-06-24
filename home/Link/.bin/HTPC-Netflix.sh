#!/bin/sh

if pgrep chromium > /dev/null; then
	echo -e 'F1\n\t~/.bin/HTPC-Netflix.sh' > ~/.config/sxhkd/sxhkdrc
	systemctl --user reload sxhkd.service
	pkill chromium
else
	/usr/bin/chromium --app=https://netflix.com &
	echo -e 'F1\n\t~/.bin/HTPC-Netflix.sh' > ~/.config/sxhkd/sxhkdrc
	echo -e 'Left\n\txdotool mousemove_relative -- -100 0' >> ~/.config/sxhkd/sxhkdrc
	echo -e 'Right\n\txdotool mousemove_relative 100 0' >> ~/.config/sxhkd/sxhkdrc
	echo -e 'Up\n\txdotool mousemove_relative -- 0 -100' >> ~/.config/sxhkd/sxhkdrc
	echo -e 'Down\n\txdotool mousemove_relative 0 100' >> ~/.config/sxhkd/sxhkdrc
	echo -e 'Return\n\txdotool click 1' >> ~/.config/sxhkd/sxhkdrc
	echo -e 'Prior\n\txdotool click 4' >> ~/.config/sxhkd/sxhkdrc
	echo -e 'Next\n\txdotool click 5' >> ~/.config/sxhkd/sxhkdrc
	systemctl --user reload sxhkd.service
fi
