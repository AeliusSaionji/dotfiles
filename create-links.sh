#!/bin/zsh
if [ -d ../dotfiles ]; then
	# (*|.*) needs bash or zsh
	ln -s home/Link/(*|.*) $HOME/
	host="$(hostnamectl status --static)"
	cwd="$(pwd)"
	if [ -d ./$host ]; then
		ln -s $cwd/$host/home/Link/(*|.*) $HOME/
		ls -l $cwd/$host/etc/modprobe.d
		printf "symlink /etc/modprobe.d (yes/no)?"
		read proceed
		if [ "$proceed" = "yes" ]; then
			sudo ln -s $cwd/$host/etc/modprobe.d/* /etc/modprobe.d/
		fi
		proceed=""
		ls -l $cwd/$host/etc/sysctl.d
		printf "symlink /etc/sysctl.d (yes/no)?"
		read proceed
		if [ "$proceed" = "yes" ]; then
			sudo ln -s $cwd/$host/etc/sysctl.d/* /etc/sysctl.d/
		fi
		proceed=""
		ls -l $cwd/$host/etc/X11/xorg.conf.d
		printf "symlink /etc/X11/xorg.conf.d (yes/no)?"
		read proceed
		if [ "$proceed" = "yes" ]; then
			sudo ln -s $cwd/$host/etc/X11/xorg.conf.d/* /etc/X11/xorg.conf.d/
		fi
	fi
else
	printf "Run this script in the root of the dotfiles folder"
	exit 1
fi
