#!/bin/zsh
color='\033[1;35m'
NC='\033[0m' # No Color
if [ -d ../dotfiles ]; then
	host="$(hostnamectl status --static)"
	cwd="$(pwd)"
	# (*|.*) needs bash or zsh
	ln -s $cwd/home/Link/(*|.*) $HOME/
	if [ -d ./$host ]; then
		ln -s $cwd/$host/home/Link/(*|.*) $HOME/
		if [ -d ./$host/etc ]; then
			printf "\nChange etc ownership to root "
			sudo chown -R root ./$host/etc
			sudo chgrp -R root ./$host/etc
			printf "\n\n----------> ls /etc/modprobe.d\n"
			ls -l $cwd/$host/etc/modprobe.d
			printf "\n${color}symlink /etc/modprobe.d (yes/no)?>${NC} "
			read proceed
			if [ "$proceed" = "yes" ]; then
				sudo ln -s $cwd/$host/etc/modprobe.d/* /etc/modprobe.d/
			fi
			proceed=""
			printf "\n\n----------> ls /etc/sysctl.d\n"
			ls -l $cwd/$host/etc/sysctl.d
			printf "\n${color}symlink /etc/sysctl.d (yes/no)?>${NC} "
			read proceed
			if [ "$proceed" = "yes" ]; then
				sudo ln -s $cwd/$host/etc/sysctl.d/* /etc/sysctl.d/
			fi
			proceed=""
			printf "\n\n----------> ls /etc/X11/xorg.conf.d\n"
			ls -l $cwd/$host/etc/X11/xorg.conf.d
			printf "\n${color}symlink /etc/X11/xorg.conf.d (yes/no)?>${NC} "
			read proceed
			if [ "$proceed" = "yes" ]; then
				sudo ln -s $cwd/$host/etc/X11/xorg.conf.d/* /etc/X11/xorg.conf.d/
			fi
		fi
	fi
else
	printf "Run this script in the root of the dotfiles folder"
	exit 1
fi
