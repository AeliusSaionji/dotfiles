#!/bin/sh
## TODO
# Accept arguments / check for $QUTE_URL, parse value and use it to filter lpass ls output

# Return the ID of the selected entry
lpid=$(lpass ls | dmenu -fn $DMENU_FONT -i -l 10 -p "Select entry" | sed -e 's/^.*id:\s//' -e 's/]$//')
# Copy the username to clipboard
lpass show $lpid --username -c
# Allow user to paste username via mouse
echo -e "Copied username; paste into page's login\nPassword will be copied next, press enter to continue" | dmenu -fn $DMENU_FONT -l 2
# Copy the password to clipboard
lpass show $lpid --password -c
