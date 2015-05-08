HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Ignore duplicate commands in history
setopt HIST_IGNORE_DUPS

# Use vi style keys
bindkey -v

# Idk
zstyle :compinstall filename '/home/Link/.zshrc'

# Enable autocompletion
autoload -Uz compinit
compinit

# Press tab twice for arrow key driven selection
zstyle ':completion:*' menu select

# Customize the shell prompt
PS1='%m%#[%~]>'

# Command aliases
alias ls="ls -h --color=auto"
alias ll="ls -lh --color=auto"
alias grep="grep -n --color=auto"
alias rm='rm -Iv --one-file-system'
alias mv=' timeout 8 mv -iv'
alias nn='ranger'
alias apacman='apacman --auronly'

# Add ~/.bin to the path
typeset -U path
path=(~/.bin $path)

# Device specific settings
host="$(hostnamectl status --static)"
if [ $host = "GIR" ]; then
	#nothing here yet
fi

# Set the window title
precmd () {
  print -Pn "\e]0;[%n@%M][%~]%#\a"
} 
preexec () { print -Pn "\e]0;[%n@%M][%~]%# ($1)\a" }

# Define a function to run things under or attach to existing tmux

run_under_tmux() {
	# Run $1 under session or attach if such session already exist.
	# $2 is optional path, if no specified, will use $1 from $PATH.
	# If you need to pass extra variables, use $2 for it as in example below..
	# Example usage:
	# 	torrent() { run_under_tmux 'rtorrent' '/usr/local/rtorrent-git/bin/rtorrent'; }
	#	mutt() { run_under_tmux 'mutt'; }
	#	irc() { run_under_tmux 'irssi' "TERM='screen' command irssi"; }


	# There is a bug in linux's libevent...
	# export EVENT_NOEPOLL=1

	command -v tmux >/dev/null 2>&1 || return 1

	if [ -z "$1" ]; then return 1; fi
	local name="$1"
	if [ -n "$2" ]; then
		local file_path="$2"
	else
		local file_path="command ${name}"
	fi

	if tmux has-session -t "${name}" 2>/dev/null; then
		tmux attach -d -t "${name}"
	else
		tmux new-session -s "${name}" "${file_path}" \; set-option status \; set set-titles-string "${name} (tmux@${HOST})"
	fi
}

# Start irssi in or attach to existing tmux
#irc() { run_under_tmux irssi; }
#irc() { dtach -A /tmp/irc -z -r winch irssi }
irc() { abduco -A /tmp/irc irssi }

# So I think this is the framework for detecting if you're running ssh, and changing colors if true
#over_ssh() {
#	if [ -n "${SSH_CLIENT}" ]; then
#		return 0
#	else
#		return 1
#	fi
#}
#
#if over_ssh && [ -z "${TMUX}" ]; then
#	prompt_is_ssh='%F{blue}[%F{red}SSH%F{blue}] '
#elif over_ssh; then
#	prompt_is_ssh='%F{blue}[%F{253}SSH%F{blue}] '
#else
#	unset prompt_is_ssh
#fi
