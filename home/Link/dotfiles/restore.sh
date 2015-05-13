rsync -avhP --chown=Link:Link --exclude-from="exclude" ./home/ /home/
host="$(hostnamectl status --static)"
if [ -d ./$host ]; then
	rsync -avhP ./$host/ /
fi
