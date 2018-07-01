#!/bin/sh

# Requires: find sed dmenu xdotool

prefix=${PASSWORD_STORE_DIR-~/.password-store}

# Generate list of password files, select one via dmenu
site=$( 
	find $prefix -path ./.git -prune -o -type f -iname '*.gpg' -printf '%P\n' \
	| sed 's/\.gpg$//' \
	| dmenu "$@"
)

[ -n $password ] || exit

# Password is first line of file
password=$(pass show "$site" | sed -n 1p)
# Username is name of file
username=$(find $prefix -wholename "*$site*" -printf '%f' | sed 's/\.gpg$//')
# Simpler code, but adds dependency on awk
#username=$(printf '%s' "$site" | awk -F / '{print $2}')
pstr=$(printf '%s\t%s' "$username" "$password")
xdotool type "$pstr"
