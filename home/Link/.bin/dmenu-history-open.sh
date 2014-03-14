cat ~/.xombrero/history | xurls | dmenu -i -b -l 10 -p 'history search' | xargs -0r xomb-open.sh
