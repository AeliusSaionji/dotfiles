#switch for each, run with delete/without/don't run
#improve sed regex (numbers vs .*)
rsync -avn --chown=Link:Link --exclude-from="exclude" ./home/Link/ /home/Link/ | sed -e '/^sent .* bytes.*bytes\/sec$/d' -e '/^total size is/d'
echo "global home > home?"
echo "Type yes to continue." && read proceed
if [ "$proceed" = "yes" ]; then
	rsync -a --chown=Link:Link --exclude-from="exclude" ./home/Link/ /home/Link/
fi
host="$(hostnamectl status --static)"
if [ -d ./$host ]; then
	proceed=""
	rsync -avn --chown=Link:Link ./$host/home/Link/ /home/Link/ | sed -e '/^sent .* bytes.*bytes\/sec$/d' -e '/^total size is/d'
	echo "$host home > home?"
	echo "Type yes to continue." && read proceed
	if [ "$proceed" = "yes" ]; then
		rsync -a --chown=Link:Link ./$host/home/Link/ /home/Link/
	fi
	proceed=""
	rsync -avn --chown=root:root --exclude="home" ./$host/ / | sed -e '/^sent .* bytes.*bytes\/sec$/d' -e '/^total size is/d'
	echo "$host root > root?"
	echo "Type yes to continue." && read proceed
	if [ "$proceed" = "yes" ]; then
		sudo rsync -a --chown=root:root --exclude="home" ./$host/ /
	fi
fi
