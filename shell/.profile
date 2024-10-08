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

# HiDPI - do not also scale with Xresources
if [ -f ~/.config/hidpi ]; then
	export QT_AUTO_SCREEN_SCALE_FACTOR=1
	export GDK_SCALE=2
fi

# Askpass script
export SUDO_ASKPASS=daskpass

# Enable vim to find the XDG compliant vimrc
export VIMINIT='let $MYVIMRC="$HOME/.config/vim/vimrc" | source $MYVIMRC'

# Misc
export LESS='--mouse -R'
export EDITOR=/usr/bin/vim
export COLORTERM=24bit
export RIPGREP_CONFIG_PATH=~/.config/ripgreprc

if [ "$OS" = 'Windows_NT' ]; then
  # Git for Windows is far more performant than msys2/git
    # Scrub from path first; then place at beginning
  gitless=$(printf '%s\n' "$PATH" | sed -e 's@/c/Program Files/Git/cmd@@' -e 's/::/:/g')
  export PATH="/c/Program Files/Git/cmd:$gitless"

  # Enable symlinks on Windows (requires devmode)
  export MSYS=winsymlinks:nativestrict

  # Use msys packages during compilation
  export SETUPTOOLS_USE_DISTUTILS=stdlib
fi

# Enable the use of ssh-agent
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
