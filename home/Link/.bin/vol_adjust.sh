#!/bin/zsh
#The math here requires zsh, this will not run in bash or sh
#Todo: make this more portable

vol=$(amixer set Master 5%$1 | sed -n -e 's/.*Playback.*\[\([0-9]*\)%\].*/\1/p' | head -n 1)
# limitations [of my understanding?]: printf must print at least 1 character
bar=$(printf '%.0s>' {0..$((vol/2))}; printf '%.0s ' {0..$((50-$((vol/2))))})
#twmnc -c "vol [$vol] [ $bar]" --id 99
#notify-send -t 0 "vol [$vol] [ $bar]"
notify-send -h int:value:$vol Volume volscript
