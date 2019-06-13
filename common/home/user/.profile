# Specify dash rc
ENV=$HOME/.shinit; export ENV

# Add bin to path
export PATH="$HOME/.local/bin:$PATH"

# mmh tweaks
export MMHP=~/.mmh-profile
export MMHEDITOR=vimeditmail
export MMHPAGER=vimpagermail

# qt programs use GTK themes
export QT_STYLE_OVERRIDE=GTK+

# HiDPI
if [ $(cat /etc/hostname) = 'BOOK' ]; then
	export QT_AUTO_SCREEN_SCALE_FACTOR=1
	export GDK_SCALE=2
fi

# Askpass script
export SUDO_ASKPASS=daskpass

# Enable vim to find the XDG compliant vimrc
export VIMINIT='let $MYVIMRC="$HOME/.config/vim/vimrc" | source $MYVIMRC'

# Misc
export LESS=-R
export EDITOR=/usr/bin/vim

# Enable the use of ssh-agent
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
