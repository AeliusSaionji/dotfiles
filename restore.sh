rsync --exclude-from="exclude" -avhP --no-o --no-g . /
host="$(hostnamectl status --static)"
if [ -d ./$host ]; then
	rsync --avhP --no-o --no-g ./$host/ /
fi
