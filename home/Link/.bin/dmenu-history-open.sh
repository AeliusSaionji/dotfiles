cat ~/.xombrero/history | sed '/^http/!d' | dmenu -i -l 10 -p 'history search' | xargs -0r xomb-open.sh
