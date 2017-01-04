# Add ~/.bin to the path
typeset -U path
path=(~/.bin $path)

# mmh tweaks
export MMHP=~/.mmh-profile
export MMHEDITOR=vimeditmail
export MMHPAGER=vimpagermail

# Steam fixes
find ~/.steam/root/ \( -name "libgcc_s.so*" -o -name "libstdc++.so*" -o -name "libxcb.so*" -o -name "libgpg-error.so*" \) -delete
#export STEAM_RUNTIME=0 #may no longer be necessary, there's a steam native.desktop

# qt programs use GTK themes
export QT_STYLE_OVERRIDE=GTK+

# Askpass script
export SUDO_ASKPASS=daskpass

# Enable vim to find the XDG compliant vimrc
export VIMINIT='let $MYVIMRC="$HOME/.config/vim/vimrc" | source $MYVIMRC'

# for the benefit of ranger shell -t
export TERMCMD=st
export LESS=-R

# Enable the use of ssh-agent
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# Start X at VT1 login
if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
	exec startx
fi
