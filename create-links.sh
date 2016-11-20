#!/bin/sh

color='\033[1;35m'
NC='\033[0m' # No Color

# Exit if not run from correct directory
[ -d ../dotfiles ] || exit 1

printf "\nLinking ${PWD}/common/home/user to ${HOME}\n"
# Link the contents of $HOME, excluding .config
find $PWD/common/home/user -maxdepth 1 -mindepth 1 \( ! -name '.config' \) -print0 | xargs -0 ln -sfvt ${HOME}/
# Link the contents of .config
find $PWD/common/home/user/.config -maxdepth 1 -mindepth 1 -print0 | xargs -0 ln -sfvt ${HOME}/.config/
# Link desktop files
find $PWD/common/home/user/.local/share/applications -maxdepth 1 -mindepth 1 -print0 | xargs -0 ln -sfvt ${HOME}/.local/share/applications/

printf "\nModifying ${PWD}/common/{etc,usr/local/bin} permissions and acls..."
# Ensure correct owner and perms for etc, bin files
sudo chown -R root:root ${PWD}/common/etc ${PWD}/common/usr
find ${PWD}/common/etc -type d -execdir sudo chmod -R 755 {} +
find ${PWD}/common/etc -type f -execdir sudo chmod -R 644 {} +
find ${PWD}/common/usr -type d -execdir sudo chmod -R 755 {} +
find ${PWD}/common/usr -type f -execdir sudo chmod -R 655 {} +
# Give current user access to these files, or we can't back up to git
find ${PWD}/common/etc -type d -execdir sudo setfacl -m u:${USER}:rwx {} +
find ${PWD}/common/etc -type f -execdir sudo setfacl -m u:${USER}:rw {} +
find ${PWD}/common/usr -type d -execdir sudo setfacl -m u:${USER}:rwx {} +
find ${PWD}/common/usr -type f -execdir sudo setfacl -m u:${USER}:rw {} +
printf "\nDone."

# Interactively choose to copy /etc/systemd/system
printf "\n\n----------> ls -l ${PWD}/common/etc/systemd/system\n"
ls -l ${PWD}/common/etc/systemd/system
printf "\n${color}copy to /etc/systemd/system (yes/no)?>${NC} "
read proceed
if [ "${proceed}" = "yes" ]; then
	sudo cp -r ${PWD}/common/etc/systemd/system/* /etc/systemd/system/
fi

# Interactively choose to link /etc/udev/rules.d
printf "\n\n----------> ls -l ${PWD}/common/etc/udev/rules.d\n"
ls -l ${PWD}/common/etc/udev/rules.d
printf "\n${color}symlink to /etc/udev/rules.d (yes/no)?>${NC} "
read proceed
if [ "${proceed}" = "yes" ]; then
	sudo ln -sfv ${PWD}/common/etc/udev/rules.d/* /etc/udev/rules.d/
fi

# Interactively choose to copy /usr/local/bin
printf "\n\n----------> ls -l ${PWD}/common/usr/local/bin\n"
ls -l ${PWD}/common/usr/local/bin
printf "\n${color}copy to /usr/local/bin (yes/no)?>${NC} "
read proceed
if [ "${proceed}" = "yes" ]; then
	sudo cp -r ${PWD}/common/usr/local/bin/* /usr/local/bin/
fi

# Per-machine config
host="$(hostnamectl status --static)"
if [ -d ${PWD}/${host} ]; then

	if [ -d ${PWD}/${host}/home ]; then
		printf "\nLinking ${PWD}/${host}/home/user to ${HOME}\n"
		# Link the contents of $HOME, excluding .config
		find $PWD/${host}/home/user -maxdepth 1 -mindepth 1 \( ! -name '.config' \) -print0 | xargs -0 ln -sfvt ${HOME}/
		# Link the contents of .config
		find $PWD/${host}/home/user/.config -maxdepth 1 -mindepth 1 -print0 | xargs -0 ln -sfvt ${HOME}/.config/
	fi

	if [ -d ${PWD}/${host}/etc ]; then
		printf "\nModifying ${PWD}/${host}/etc permissions and acls..."
		# Ensure correct owner and perms for etc files
		sudo chown -R root:root ${PWD}/${host}/etc
		find ${PWD}/${host}/etc -type d -execdir sudo chmod -R 755 {} +
		find ${PWD}/${host}/etc -type f -execdir sudo chmod -R 644 {} +
		# Give current user access to these files, or we can't back up to git
		find ${PWD}/${host}/etc -type d -execdir sudo setfacl -m u:${USER}:rwx {} +
		find ${PWD}/${host}/etc -type f -execdir sudo setfacl -m u:${USER}:rw {} +
		printf "\nDone."

		# Interactively choose to link /etc/modprobe.d
		printf "\n\n----------> ls -l ${PWD}/${host}/etc/modprobe.d\n"
		ls -l ${PWD}/${host}/etc/modprobe.d
		printf "\n${color}symlink to /etc/modprobe.d (yes/no)?>${NC} "
		read proceed
		if [ "${proceed}" = "yes" ]; then
			sudo ln -sfv ${PWD}/${host}/etc/modprobe.d/* /etc/modprobe.d/
		fi

		# Interactively choose to link /etc/sysctl.d
		printf "\n\n----------> ls -l ${PWD}/${host}/etc/sysctl.d\n"
		ls -l ${PWD}/${host}/etc/sysctl.d
		printf "\n${color}symlink to /etc/sysctl.d (yes/no)?>${NC} "
		read proceed
		if [ "${proceed}" = "yes" ]; then
			sudo ln -sfv ${PWD}/${host}/etc/sysctl.d/* /etc/sysctl.d/
		fi

		# Interactively choose to link /etc/systemd/system
		printf "\n\n----------> ls -l ${PWD}/${host}/etc/systemd/system\n"
		ls -l ${PWD}/${host}/etc/systemd/system
		printf "\n${color}copy to /etc/systemd/system (yes/no)?>${NC} "
		read proceed
		if [ "${proceed}" = "yes" ]; then
			sudo cp -r ${PWD}/${host}/etc/systemd/system/* /etc/systemd/system/
		fi

		# Interactively choose to link /etc/X11/xorg.conf.d
		printf "\n\n----------> ls -l ${PWD}/${host}/etc/X11/xorg.conf.d\n"
		ls -l ${PWD}/${host}/etc/X11/xorg.conf.d
		printf "\n${color}symlink to /etc/X11/xorg.conf.d (yes/no)?>${NC} "
		read proceed
		if [ "${proceed}" = "yes" ]; then
			sudo ln -sfv ${PWD}/${host}/etc/X11/xorg.conf.d/* /etc/X11/xorg.conf.d/
		fi
	fi
fi
