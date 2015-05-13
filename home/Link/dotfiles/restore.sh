rsync --exclude-from="exclude" -avhP --chown=Link:Link ./home/ /home/
host="$(hostnamectl status --static)"
if [ -d ./$host ]; then
	rsync --avhP ./$host/ /
fi
