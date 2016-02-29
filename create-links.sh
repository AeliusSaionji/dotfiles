#!/bin/zsh
color='\033[1;35m'
NC='\033[0m' # No Color
if [ -d ../dotfiles ]; then
	printf "\nChange etc ownership to root "
	sudo chown -R root $PWD/etc
	sudo chgrp -R root $PWD/etc
	printf "\n\n----------> ls /etc/systemd/system\n"
	ls -l $PWD/etc/systemd/system
	printf "\n${color}symlink /etc/systemd/system (yes/no)?>${NC} "
	read proceed
	if [ "$proceed" = "yes" ]; then
		sudo ln -sf $PWD/etc/systemd/system/* /etc/systemd/system/
	fi
	proceed=""
	printf "\n\n----------> ls /etc/udev/rules.d\n"
	ls -l $PWD/etc/udev/rules.d
	printf "\n${color}symlink /etc/udev/rules.d (yes/no)?>${NC} "
	read proceed
	if [ "$proceed" = "yes" ]; then
		sudo ln -sf $PWD/etc/udev/rules.d/* /etc/udev/rules.d/
	fi
	proceed=""
	host="$(hostnamectl status --static)"
	# (*|.*) needs bash or zsh
	ln -s $PWD/home/Link/(*|.*) $HOME/
	if [ -d $PWD/$host ]; then
		ln -s $PWD/$host/home/Link/(*|.*) $HOME/
		if [ -d $PWD/$host/etc ]; then
			printf "\nChange etc ownership to root "
			sudo chown -R root $PWD/$host/etc
			sudo chgrp -R root $PWD/$host/etc
			printf "\n\n----------> ls /etc/modprobe.d\n"
			ls -l $PWD/$host/etc/modprobe.d
			printf "\n${color}symlink /etc/modprobe.d (yes/no)?>${NC} "
			read proceed
			if [ "$proceed" = "yes" ]; then
				sudo ln -sf $PWD/$host/etc/modprobe.d/* /etc/modprobe.d/
			fi
			proceed=""
			printf "\n\n----------> ls /etc/sysctl.d\n"
			ls -l $PWD/$host/etc/sysctl.d
			printf "\n${color}symlink /etc/sysctl.d (yes/no)?>${NC} "
			read proceed
			if [ "$proceed" = "yes" ]; then
				sudo ln -sf $PWD/$host/etc/sysctl.d/* /etc/sysctl.d/
			fi
			proceed=""
			printf "\n\n----------> ls /etc/systemd/system\n"
			ls -l $PWD/$host/etc/systemd/system
			printf "\n${color}symlink /etc/systemd/system (yes/no)?>${NC} "
			read proceed
			if [ "$proceed" = "yes" ]; then
				sudo ln -sf $PWD/$host/etc/systemd/system/* /etc/systemd/system/
			fi
			proceed=""

			printf "\n\n----------> ls /etc/X11/xorg.conf.d\n"
			ls -l $PWD/$host/etc/X11/xorg.conf.d
			printf "\n${color}symlink /etc/X11/xorg.conf.d (yes/no)?>${NC} "
			read proceed
			if [ "$proceed" = "yes" ]; then
				sudo ln -sf $PWD/$host/etc/X11/xorg.conf.d/* /etc/X11/xorg.conf.d/
			fi
		fi
	fi
else
	printf "Run this script in the root of the dotfiles folder"
	exit 1
fi
