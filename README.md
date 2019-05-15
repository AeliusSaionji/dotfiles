# FSDE

## Overview

### Logical Flow

* Display Manager sddm boots into X11 via a 'session' file from `/usr/share/xsessions`
* Session `xinitrc` configures input devices, screensaver/lockscreen timeout, pulseaudio error bell, x11.target hook (for user services depending on x11), runs dwm in a loop
	+ Session provided by my custom dwm. See <https://github.com/AeliusSaionji/abs/tree/master/dwm-git>
* dwm itself sets environment vars for `~/.local/bin/dmenu` via `config.h`
	+ Rather than exporting a font just for dmenu in `~/.profile`, dmenu will inherit the user configured font for dwm.
* dwm handles keyboard shortcuts, no need for xbindkeys
* `~/.local/bin/fondler.sh` interprets many dwm keybinds
	+ Default shell is sh/dash
* `~/.profile` sets up the environment
	+ Adds `~/.local/bin` to `$PATH`
	+ Exports various environment variables
* `~/.shinit` (the configrc of sh/dash) is used to launch another shell
	+ Launching our preferred interactive shell in this way has two benefits:
		1. The environment config becomes a permanent and portable part of the system, and users need not worry about correctly porting it to their preferred shell.
		2. Some arch startup scripts rely on an sh compatible shell interpretter, so it makes sense to drop into a secondary shell only after login.

### Terminal: st <https://github.com/AeliusSaionji/abs/tree/master/st-git>
* `MOD` is Left Alt (not currently used by anything)
* `Ctrl-Shift-l` opens a dmenu based url launcher
* `Ctrl-Shift-c` copy to clipboard
* `Ctrl-Shift-v` pastes from clipboard
* terminal font: inconsolata
	+ font recommended by diablo to consider: adobe source code pro

### WM: dwm <https://github.com/AeliusSaionji/abs/tree/master/dwm-git>
* `MOD` is Windows key or the Appskey aka menukey
* `MOD-Space` activates dmenu via j4-dmenu-desktop, a shortcut/desktop launcher
* `MOD-Alt-Space` activates dmenu via ~/.local/bin/run-recent, a program launcher
* `MOD-Shift-Enter` launches the terminal, st
* `MOD-Ctrl-Enter` launches st in a popup window
* Open URLs: `MOD-u` opens selected text with `~/.local/bin/fondler.sh` via `xdg-open`

## Misc Notes

### Automatic sleep / suspend

xfce, mate, lxqt, kde all have power managers you can install- but they seem to
implement their own idle detection, and will put the computer to sleep in the
middle of you watching a movie. In theory, the display manager should enable
the X11 session to report to logind whether or not the current session is idle,
and logind can perform idleactions. Seems like a nice official solution, but I
can't get it to work at all.  I think I found a better solution, though!
Somehow, programs are correctly inhibiting the X11 screensaver. Not sure when
this started working or by what mechanism, but this is the basis for how I
handle sleeping. I wrote the script `suspend-countdown.sh`, to be used by
`xss-lock`. My "screensaver" is just a script that shows a countdown and puts
the computer to sleep when finished. `xss-lock` takes care of all the
complicated aspects and this works flawlsesly. The script at the time of
writing will not start the countdown if audio is playing, specifically because
plexmediaplayer doesn't inhibit the screensaver (the only app I know of which
doesn't have this worked out ;-_-). `xss-lock` also of course ensures that the
lockscreen is activated whenever the computer goes to sleep.  Lidswitch actions
are handled by logind, because you want laptops to go to sleep even while in
the display manager. I begrudgingly installed `mate-power-manager`, because
it's the only power manager that lets you configure it to NOT do things.  The
only thing it needs to do is hibernate the PC when the battery is at critical
level. I tried to write udev rules and scripts for this in years past, but
using shell scripting to create a generic solution for different devices which
might have multiple batteries turned out to be pretty complicated. Also udev
rules kind of suck. So, I let someone else do the work. Last, on systems for
which you have enabled hibernation, you can make use of
`suspend-then-hibernate`. Configure the delay in `/etc/systemd/sleep.conf` and
symlimk `sudo ln -s
/usr/lib/systemd/system/systemd-suspend-then-hibernate.service
/etc/systemd/system/systemd-suspend.service` to make sure this always happens
even when just 'suspend' is invoked.

### Autostarting X11 programs with systemd services

Somehow the X11 display is unavailable early in the startup process and many
services will fail to start, or start but not actually function as intended.
The solution I have come up for this is to just create an override for every
such service. In the `.xinitrc` we manually start `x11.target`, which is a
target of my own creation. Create overrides for all problem services to ensure
they do not start until `x11.target` is started by running `systemctl --user
edit whatever.service` and adding the following to the file:

```
[Unit]
Requisite=x11.target

[Install]
WantedBy=x11.target
```

### Transparency

I'm using inactive window transparency from compton. Every window which is not
focused will be transparent. Create exclusions on the fly with `Mod-e`. I've
done this because I like seeing my wallpaper and because I also find dwm's
rendering of the active window not easy to spot. All it does is change the
color of the window border. So, I've eliminated the border entirely (set to 0
pixels) and rely on transparency to highligh which window is the active window.
I also set a pretty hard glow around the active window to really make it clear.

#### Transparency Notes
* qiv doesn't set the background wallpaper in a way that works with transparency
	+ I no longer use qiv at all, but this note is useful
* st has transparency compiled in from the source (via a patch)
	+ the patch breaks ranger's image previews
	+ hopefully st will get libsixel soon, and both will work
* compton is newer than xcompmgr, use compton

## Necessities & Deps

- abduco
- compton
	* handles transparency and flashy effects
- dash
- dex
- dmenu
- dunst
	* displays popup notifications
	* recently deprecated
- aur/dvtm-git
	* git version because title/corruption fix
	* probably phasing this out for tmux, since development has stopped,
	  and the problems with dvtm are accumulating.
- feh
	* sets the wallpaper
- aur/j4-dmenu-desktop
	* primary launcher
- libnotify
- lxappearance
	* set gtk, mouse themes
- mate-power-manager
	* low battery actions, maybe battery stats?
- aur/mimeo
	* xdg-open sucks
- perl-file-mimeinfo
	* without this, xdg-open uses 'file' to decide what a file is, which sucks
- sound-theme-freedesktop
- tlp
	* install and forget power manager; need to enable systemd service though
- ttf-dejavu
	* browsers
- ttf-hanazono
	* everything else and maybe jpn letters?
- ttf-inconsolata
	* terminal
- udevil
	* mount everything as a user, automount devices
- aur/xdg-utils-mimeo
	* xdg-open sucks
	* this replaces xdg-utils
- xf86-input-synaptics
	* can't configure touchpad without this
	* try dumping for libinput
- xorg-xbacklight
- xorg-xprop
	* scripts
- xorg-xrandr
	* screen rotation
	* multi monitor display setting
- xorg-xsetroot
	* dwm statusbar
- xorg-xwininfo
	* scripts
- xsel
	* `fondler.sh` url launching
	* ranger
- aur/xss-lock
	* for running slock when appropriate.
	* script relies on this to suspend-on-idle

## Good Software

- ranger
	* file manager
- sxiv
	* image viewer
- zathura
	* pdf / other viewer

## systemctl enables

- enable fstrim.timer for SSDs maybe
- enable tlp for laptop power saving
- missing a lot here

## Device Considerations

### Talim

- Mute key is hardwired to mute the speaker, no need to bind it.
- libva-intel-driver-g45-h264 - video hw decoding for ancient gpu

### NERV

- Using pulseaudio to set default soundcard

## Misc

### Extract `.deb`

* Extract contents of `.deb`
* `ar vx package.deb`
* `tar xf data.tar.gz`

### Programs I'll never remember

* baobab
	+ awesome disk usage visualizer
* dconf-editor
 	+ config editor for a wide variety of programs (gtk or kde config database?)
* fbgrab
	+ VT screenshot
* fbv
	+ VT image viewer
* okular
	+ touch friendly, bloated, feature complete pdf/etc viewer
* unclutter-xfixes-git
	+ hide mouse cursor after timeout

### Files I'll never remember

* `~/.config/user-dirs.dirs` for telling firefox to not make the Desktop folder

### Identify Hardlinks

	ls -i = inode #, find -inum <#>
	find -printf "%n %p\n" %n is number of hardlinks
	find -samefile <file>

### Samba share mounting

There are a few ways- topmost entry is what I'm currently trialing

1. udevil
	cp /etc/udevil/udevil.conf /etc/udevil/udevil-user-aelius.conf
	add cifs to allowed_types, add credentials=/etc/cifs_creds to default_options_cifs
	touch /etc/udevil/cifs_aelius && chmod 600 /etc/udevil/cifs_aelius, newline separated username= password=
	udevil mount //server/mount
2. smbnetfs
	Makes the WORKGROUP domain generally browseable, but permissions are all wrong
3. Use fstab to auto mount predefined shares upon accessing, and auto unmount after idle timeout
	<https://wiki.archlinux.org/index.php/Fstab#Automount_with_systemd>
	<https://wiki.archlinux.org/index.php/Samba#Add_Share_to_.2Fetc.2Ffstab>
	//server/share /mntpoint cifs credentials=file,uid=localLinuxUser,gid=users,noauto,x-systemd.automount,x-systemd.idle-timeout=1min,x-systemd.requires=network-online.target 0 0
	Unless uid and gid are set, root will own the mount and all files
	noauto prevents mounting at boot and mounting with mount -a
	x-systemd.automount apparently mounts the entry when someone tries to access the mount point
	x-systemd.idle-timeout=1min unmounts the entry when the mount point has not been touched in 1 minute
	x-systemd.device-timeout does not apply to cifs

### Skype for linux won't stay logged in

Install gnome-keyring

### Synclient can't connect to synaptics driver

Install `xf86-input-evdev`, uninstall `xf86-input-libinput` (which overrides synptics).
`xorg-server` depends on at least one of those, you can't uninstall one without having the other installed.

### Scripting

I've taken to just using `test` statements combined with `&&` and `||` in place
of if- partially because it takes up less lines, partially because I have this
untested notion that it might be more efficient to execute. I should look into
that. Something to remember is that it cannot replace `if` in all scenarios,
particularly when using functions. `["$false"] && ["$(function_1)"] ||
["$(function_2)"]` This may seem obvious, but my sleep deprived self had a hard
time understanding why both of those functions were being executed. Actually I
still don't know why; I think that first `$false` should fail the left side of
the `||` immediately. Well, if the `$false` wasn't there, it makes sense that
`function_1` would be executed- it has to be tested to see if it returns 1 or
0. An `if` statement must be used here to protect the functions from being
treated as part of the conditional evaluation. Similarly, while that above
example would work fine if it doesn't matter that both sides of the `||` are
executed, another problem we run into is bad return codes. If a `test`
statement returns `1`, so does the entire script. While this doesn't hurt
anything, a script which runs successfully shouldn't be spitting out nonzero
returns; an `if` statement will allow better control of the return codes.
