HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Ignore duplicate commands in history
setopt HIST_IGNORE_DUPS

# Use vi style keys
bindkey -v
bindkey jj vi-cmd-mode

# Idk
zstyle :compinstall filename '/home/Link/.zshrc'

# More Vim stuff?
function zle-line-init zle-keymap-select {
	RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
	RPS2=$RPS1
	zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# Enable autocompletion
autoload -Uz compinit
compinit

# Press tab twice for arrow key driven selection
zstyle ':completion:*' menu select

# Customize the shell prompt
PS1='%m%#[%~]>'

# Command aliases
alias grep='grep --color=auto'
alias ls='ls --color=auto --quoting-style=literal --indicator-style=slash'
alias ll='ls --color=auto --quoting-style=literal --indicator-style=slash -l'
alias  l='ls --color=auto --quoting-style=literal --indicator-style=slash -l'
alias rm='rm -Iv --one-file-system'
alias vc='vimcat'
alias vp='vimpager'

# https://wiki.archlinux.org/index.php/Zsh#cdr
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# Set the window title
precmd () {
  print -Pn "\e]0;[%n@%M][%~]%#\a"
} 
preexec () { print -Pn "\e]0;[%n@%M][%~]%# ($1)\a" }

# Run or raise ranger
ranger() {
	if [ -z "$RANGER_LEVEL" ] && [ -z "$1" ]; then
		/usr/bin/ranger
	elif [ -n "$1" ]; then
		/usr/bin/ranger "$1"
	else
		exit
	fi
}

