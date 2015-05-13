sed '/^http/!d' ~/.xombrero/history | dmenu -f -i -l 10 -p 'history search' | xargs -0r xomb-open.sh
