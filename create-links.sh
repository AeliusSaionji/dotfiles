#!/bin/zsh
# (*|.*) needs bash or zsh
ln -s $HOME/dotfiles/home/Link/(*|.*) $HOME/
host="$(hostnamectl status --static)"
if [ -d $HOME/dotfiles/$host ]; then
	ln -s $HOME/dotfiles/$host/home/Link/(*|.*) $HOME/
fi
