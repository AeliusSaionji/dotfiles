#!/bin/sh

# Requires: find sed dmenu xdotool

# Detect user set pass dir
prefix=${PASSWORD_STORE_DIR-~/.password-store}

# Generate list of password files, select one via dmenu
site=$( 
	find "$prefix" -path '*/.git' -prune -o -type f -iname '*.gpg' -printf '%P\n' \
	| sed 's/\.gpg$//' \
	| dmenu "$@"
)

# If $site is empty for any reason, exit script
[ -z "$site" ] && exit

# Password is first line of file
password=$(pass show "$site" | sed -n 1p)

# If pass is empty, exit script
[ -z "$password" ] && exit

# Username is name of file
username=$(find "$prefix" -path "${prefix}*${site}.gpg" -printf '%f\n' | sed 's/\.gpg$//')
# Simpler code, but adds dependency on awk
#username=$(printf '%s' "$site" | awk -F / '{print $2}')

# Condense string into a typeable format, separating user and pass with tab
pstr=$(printf '%s\t%s' "$username" "$password")
xdotool type "$pstr"

unset password username pstr prefix site
