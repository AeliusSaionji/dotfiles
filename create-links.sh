#!/bin/sh

color='\033[1;35m'
NC='\033[0m' # No Color

[ -d ../dotfiles ] || exit 1

printf "\nLinking ${PWD}/common/home/user to ${HOME}\n"
find $PWD/common/home/user -maxdepth 1 -mindepth 1 \( ! -name '.config' \) -print0 | xargs -0 ln -sfvt ${HOME}/
find $PWD/common/home/user/.config -maxdepth 1 -mindepth 1 -print0 | xargs -0 ln -sfvt ${HOME}/.config/
find $PWD/common/home/user/.local/share/applications -maxdepth 1 -mindepth 1 -print0 | xargs -0 ln -sfvt ${HOME}/.local/share/applications/

printf "\nModifying ${PWD}/common/etc permissions and acls..."
sudo chown -R root:root ${PWD}/common/etc
find ${PWD}/common/etc -type d -execdir sudo chmod -R 755 {} +
find ${PWD}/common/etc -type f -execdir sudo chmod -R 644 {} +
find ${PWD}/common/etc -type d -execdir sudo setfacl -m u:${USER}:rwx {} +
find ${PWD}/common/etc -type f -execdir sudo setfacl -m u:${USER}:rw {} +
printf "\nDone."

printf "\n\n----------> ls -l ${PWD}/common/etc/systemd/system\n"
ls -l ${PWD}/common/etc/systemd/system
printf "\n${color}symlink to /etc/systemd/system (yes/no)?>${NC} "
read proceed
if [ "${proceed}" = "yes" ]; then
	sudo ln -sfv ${PWD}/common/etc/systemd/system/* /etc/systemd/system/
fi
proceed=""

printf "\n\n----------> ls -l ${PWD}/common/etc/udev/rules.d\n"
ls -l ${PWD}/common/etc/udev/rules.d
printf "\n${color}symlink to /etc/udev/rules.d (yes/no)?>${NC} "
read proceed
if [ "${proceed}" = "yes" ]; then
	sudo ln -sfv ${PWD}/common/etc/udev/rules.d/* /etc/udev/rules.d/
fi
proceed=""

host="$(hostnamectl status --static)"
if [ -d ${PWD}/${host} ]; then

	if [ -d ${PWD}/${host}/home ]; then
		printf "\nLinking ${PWD}/${host}/home/user to ${HOME}\n"
		find $PWD/${host}/home/user -maxdepth 1 -mindepth 1 \( ! -name '.config' \) -print0 | xargs -0 ln -sfvt ${HOME}/
		find $PWD/${host}/home/user/.config -maxdepth 1 -mindepth 1 -print0 | xargs -0 ln -sfvt ${HOME}/.config/
	fi

	if [ -d ${PWD}/${host}/etc ]; then

		printf "\nModifying ${PWD}/${host}/etc permissions and acls..."
		sudo chown -R root:root ${PWD}/${host}/etc
		find ${PWD}/${host}/etc -type d -execdir sudo chmod -R 755 {} +
		find ${PWD}/${host}/etc -type f -execdir sudo chmod -R 644 {} +
		find ${PWD}/${host}/etc -type d -execdir sudo setfacl -m u:${USER}:rwx {} +
		find ${PWD}/${host}/etc -type f -execdir sudo setfacl -m u:${USER}:rw {} +
		printf "\nDone."

		printf "\n\n----------> ls -l ${PWD}/${host}/etc/modprobe.d\n"
		ls -l ${PWD}/${host}/etc/modprobe.d
		printf "\n${color}symlink to /etc/modprobe.d (yes/no)?>${NC} "
		read proceed
		if [ "${proceed}" = "yes" ]; then
			sudo ln -sfv ${PWD}/${host}/etc/modprobe.d/* /etc/modprobe.d/
		fi
		proceed=""

		printf "\n\n----------> ls -l ${PWD}/${host}/etc/sysctl.d\n"
		ls -l ${PWD}/${host}/etc/sysctl.d
		printf "\n${color}symlink to /etc/sysctl.d (yes/no)?>${NC} "
		read proceed
		if [ "${proceed}" = "yes" ]; then
			sudo ln -sfv ${PWD}/${host}/etc/sysctl.d/* /etc/sysctl.d/
		fi
		proceed=""

		printf "\n\n----------> ls -l ${PWD}/${host}/etc/systemd/system\n"
		ls -l ${PWD}/${host}/etc/systemd/system
		printf "\n${color}symlink to /etc/systemd/system (yes/no)?>${NC} "
		read proceed
		if [ "${proceed}" = "yes" ]; then
			sudo ln -sfv ${PWD}/${host}/etc/systemd/system/* /etc/systemd/system/
		fi
		proceed=""

		printf "\n\n----------> ls -l ${PWD}/${host}/etc/X11/xorg.conf.d\n"
		ls -l ${PWD}/${host}/etc/X11/xorg.conf.d
		printf "\n${color}symlink to /etc/X11/xorg.conf.d (yes/no)?>${NC} "
		read proceed
		if [ "${proceed}" = "yes" ]; then
			sudo ln -sfv ${PWD}/${host}/etc/X11/xorg.conf.d/* /etc/X11/xorg.conf.d/
		fi
	fi
fi
