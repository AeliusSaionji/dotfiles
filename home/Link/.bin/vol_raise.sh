#!/bin/zsh
#The math here requires zsh, this will not run in bash or sh
#Todo: make this more portable

vol=$(amixer set Master 5%+ | sed -n -e 's/.*Playback.*\[\([0-9]*\)%\].*/\1/p' | head -n 1)
#bar=$(echo -ne [ ; printf '%.0s#' {1..$vol}; printf '%.0s ' {1..$((100-$vol))}; echo ])
twmnc -c "Volume: $vol" --id 99
