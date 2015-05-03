if (pgrep -x xombrero)
then
	xombrero -n "$1" &
else
	xombrero "$1" &
fi
