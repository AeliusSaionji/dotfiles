if [[ -e ~/.xombrero/socket ]]
then
	xombrero -e "open "$1"" &
else
	xombrero "$1" &
fi
