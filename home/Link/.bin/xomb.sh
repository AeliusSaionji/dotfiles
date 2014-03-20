if [[ -e ~/.xombrero/socket ]]
then
	xombrero -n "$1" &
else
	xombrero "$1" &
fi
