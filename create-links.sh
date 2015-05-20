#!/bin/sh
# maybe use find here
ln -rs ~/dotfiles/home/Link/.* ~/
ln -rs ~/dotfiles/home/Link/* ~/
host="$(hostnamectl status --static)"
if [ -d ./$host ]; then
	ln -rs ~/dotfiles/$host/home/Link/.* ~/
#	ln -rs ~/dotfiles/$host/home/Link/* ~/
fi
