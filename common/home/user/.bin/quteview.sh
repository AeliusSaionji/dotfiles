#!/bin/bash

# This script is meant to emulate the functionality of mh/nmh/mmh "show"
# I prefer to have 'show' print to the terminal, but sometimes this
# doesn't produce readable results. With this script I can quickly re-open
# the current (or any) mail with a graphical program.

# TODO
# - Attachments are stored but are not easily accessible. Perhaps,
	# a qutebrowser userscript to list all items in cache?
# - Clean cache before running mhstore, drop all 'if's, open "cache/*" ?

# Let mhstore do its thing, exit if it fails to run
mhstore "$@" || exit

# If no arguments provided, read from context
if [ -z $1 ]; then
	read -r context < $HOME/.mmh/context
	read -r current < .mail/mh/${context/Current-Folder: /}/.mh_sequences
	current=${current/c: /}
# If first argument is a mail number, use it
elif [ $1 -gt 0 ]; then
	current=$1
# If first argument is not a number, $2 is, then use $2.
elif [ $2 -gt 0 ]; then
	current=$2
fi

# Open using qutebrowser in a floating window
qutebrowser --backend webengine --qt-arg name popwww --basedir /tmp "${HOME}/.cache/mmh/${current}."*
