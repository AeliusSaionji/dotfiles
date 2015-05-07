rsync --exclude-from="exclude" -avhP --no-o --no-g . /
host="$(hostnamectl status --static)"
if [ $host = "GIR" ]; then
	rsync --avhP --no-o --no-g ./GIR/ /
elif [ $host = "Saya" ]; then
	rsync --avhP --no-o --no-g ./Saya/ /
fi
