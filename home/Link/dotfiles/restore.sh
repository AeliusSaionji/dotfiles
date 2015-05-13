rsync -avhP --chown=Link:Link --exclude-from="exclude" ./home/Link/ /home/Link/
host="$(hostnamectl status --static)"
if [ -d ./$host ]; then
	sudo rsync -avhP --chown=root:root ./$host/ /
fi
