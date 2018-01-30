#!/bin/sh

# TODO
# make consistent use of ln
# script is twice as long as it needs to be; utilize functions, reuse code
# fix nerv pulse; daemon wouldnt start with symlinked .config/pulse, need to create folder and symlink config
# systemctl --user enable declaration. symlinks in git contain username, not portable

# Exit if not run from correct directory
[ -d ../dotfiles ] || exit 1

color='\033[1;35m'
NC='\033[0m' # No Color
dotdir="${PWD}"

###
## User HOME
###

printf "\nLinking ${dotdir}/common/home/user to ${HOME}\n"
# Link the contents of upstream $HOME, excluding .config
find ${dotdir}/common/home/user -maxdepth 1 -mindepth 1 \( ! -name '.config' \) \( ! -name '.local' \) -print0 | xargs -0 ln -srfvt ${HOME}/
# Link the contents of upstream .config
mkdir -p ${HOME}/.config
find ${dotdir}/common/home/user/.config -maxdepth 1 -mindepth 1 -print0 | xargs -0 ln -srfvt ${HOME}/.config/
# Link upstream desktop files
mkdir -p ${HOME}/.local/share/applications
find ${dotdir}/common/home/user/.local/share/applications -maxdepth 1 -mindepth 1 -print0 | xargs -0 ln -srfvt ${HOME}/.local/share/applications/
# Link upstream bin files
ln -srfvt ${HOME}/.local/ ${dotdir}/common/home/user/.local/bin


###
## System
###

printf "\nModifying ${dotdir}/common/{etc,usr/local/bin} permissions and acls..."
# Ensure correct owner and perms for etc, bin files
sudo chown -R root:root ${dotdir}/common/etc ${dotdir}/common/usr
find ${dotdir}/common/etc -type d -execdir sudo chmod -R 755 {} +
find ${dotdir}/common/etc -type f -execdir sudo chmod -R 644 {} +
find ${dotdir}/common/usr         -execdir sudo chmod -R 755 {} +
# Give current user access to these files, or we can't back up to git
find ${dotdir}/common/etc -type d -execdir sudo setfacl -m u:${USER}:rwx {} +
find ${dotdir}/common/etc -type f -execdir sudo setfacl -m u:${USER}:rw  {} +
find ${dotdir}/common/usr         -execdir sudo setfacl -m u:${USER}:rwx {} +
printf "\nDone."

# Interactively choose to copy /etc
printf "\n\n----------> ls -l ${dotdir}/common/etc\n"
find ${dotdir}/common/etc -maxdepth 1 -type f -print
printf "\n${color}symlink to /etc (yes/no)?>${NC} "
read proceed
if [ "${proceed}" = "yes" ]; then
	find ${dotdir}/common/etc -maxdepth 1 -type f \
	-execdir sudo ln -sfvt /etc "${dotdir}/common/etc/{}" \;
fi

# Interactively choose to copy /etc/systemd/system
printf "\n\n----------> ls -l ${dotdir}/common/etc/systemd/system\n"
ls -l ${dotdir}/common/etc/systemd/system
printf "\n${color}copy to /etc/systemd/system (yes/no)?>${NC} "
read proceed
if [ "${proceed}" = "yes" ]; then
	sudo cp -r ${dotdir}/common/etc/systemd/system/* /etc/systemd/system/
fi

# Interactively choose to link /etc/udev/rules.d
printf "\n\n----------> ls -l ${dotdir}/common/etc/udev/rules.d\n"
ls -l ${dotdir}/common/etc/udev/rules.d
printf "\n${color}symlink to /etc/udev/rules.d (yes/no)?>${NC} "
read proceed
if [ "${proceed}" = "yes" ]; then
	sudo ln -sfv ${dotdir}/common/etc/udev/rules.d/* /etc/udev/rules.d/
fi

# Interactively choose to copy /usr/local/bin
printf "\n\n----------> ls -l ${dotdir}/common/usr/local/bin\n"
ls -l ${dotdir}/common/usr/local/bin
printf "\n${color}copy to /usr/local/bin (yes/no)?>${NC} "
read proceed
if [ "${proceed}" = "yes" ]; then
	sudo cp -r ${dotdir}/common/usr/local/bin/* /usr/local/bin/
fi

# Per-machine config
host="$(hostnamectl status --static)"
if [ -d ${dotdir}/${host} ]; then

	if [ -d ${dotdir}/${host}/home ]; then
		printf "\nLinking ${dotdir}/${host}/home/user to ${HOME}\n"
		# Link the contents of $HOME, excluding .config
		find ${dotdir}/${host}/home/user -maxdepth 1 -mindepth 1 \( ! -name '.config' \) -print0 | xargs -0 ln -srfvt ${HOME}/
		# Link the contents of .config
		find ${dotdir}/${host}/home/user/.config -maxdepth 1 -mindepth 1 -print0 | xargs -0 ln -srfvt ${HOME}/.config/
	fi

	if [ -d ${dotdir}/${host}/etc ]; then
		printf "\nModifying ${dotdir}/${host}/etc permissions and acls..."
		# Ensure correct owner and perms for etc files
		sudo chown -R root:root ${dotdir}/${host}/etc
		find ${dotdir}/${host}/etc -type d -execdir sudo chmod -R 755 {} +
		find ${dotdir}/${host}/etc -type f -execdir sudo chmod -R 644 {} +
		# Give current user access to these files, or we can't back up to git
		find ${dotdir}/${host}/etc -type d -execdir sudo setfacl -m u:${USER}:rwx {} +
		find ${dotdir}/${host}/etc -type f -execdir sudo setfacl -m u:${USER}:rw {} +
		printf "\nDone."

		# Interactively choose to copy /etc
		printf "\n\n----------> ls -l ${dotdir}/${host}/etc\n"
		find ${dotdir}/${host}/etc -maxdepth 1 -type f -print
		printf "\n${color}symlink to /etc (yes/no)?>${NC} "
		read proceed
		if [ "${proceed}" = "yes" ]; then
			find ${dotdir}/${host}/etc -maxdepth 1 -type f \
			-execdir sudo ln -sfvt /etc "${dotdir}/${host}/etc/{}" \;
		fi

		# Interactively choose to link /etc/modprobe.d
		printf "\n\n----------> ls -l ${dotdir}/${host}/etc/modprobe.d\n"
		ls -l ${dotdir}/${host}/etc/modprobe.d
		printf "\n${color}symlink to /etc/modprobe.d (yes/no)?>${NC} "
		read proceed
		if [ "${proceed}" = "yes" ]; then
			sudo ln -sfv ${dotdir}/${host}/etc/modprobe.d/* /etc/modprobe.d/
		fi

		# Interactively choose to link /etc/sysctl.d
		printf "\n\n----------> ls -l ${dotdir}/${host}/etc/sysctl.d\n"
		ls -l ${dotdir}/${host}/etc/sysctl.d
		printf "\n${color}symlink to /etc/sysctl.d (yes/no)?>${NC} "
		read proceed
		if [ "${proceed}" = "yes" ]; then
			sudo ln -sfv ${dotdir}/${host}/etc/sysctl.d/* /etc/sysctl.d/
		fi

		# Interactively choose to link /etc/systemd/system
		printf "\n\n----------> ls -l ${dotdir}/${host}/etc/systemd/system\n"
		ls -l ${dotdir}/${host}/etc/systemd/system
		printf "\n${color}copy to /etc/systemd/system (yes/no)?>${NC} "
		read proceed
		if [ "${proceed}" = "yes" ]; then
			sudo cp -r ${dotdir}/${host}/etc/systemd/system/* /etc/systemd/system/
		fi

		# Interactively choose to link /etc/X11/xorg.conf.d
		printf "\n\n----------> ls -l ${dotdir}/${host}/etc/X11/xorg.conf.d\n"
		ls -l ${dotdir}/${host}/etc/X11/xorg.conf.d
		printf "\n${color}symlink to /etc/X11/xorg.conf.d (yes/no)?>${NC} "
		read proceed
		if [ "${proceed}" = "yes" ]; then
			sudo ln -sfv ${dotdir}/${host}/etc/X11/xorg.conf.d/* /etc/X11/xorg.conf.d/
		fi
	fi
fi
