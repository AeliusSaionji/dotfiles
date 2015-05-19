#switch for each, run with delete/without/don't run
#improve sed regex (numbers vs .*)
color='\033[1;35m'
NC='\033[0m' # No Color
rsync -avn --chown=Link:Link --exclude-from="exclude" ./home/Link/ /home/Link/ | sed -e '/^sent .* bytes.*bytes\/sec$/d' -e '/^total size is/d'
printf "${color}global home > home? (yes/no) : ${NC}"
read proceed
if [ "$proceed" = "yes" ]; then
	rsync -a --chown=Link:Link --exclude-from="exclude" ./home/Link/ /home/Link/
fi
host="$(hostnamectl status --static)"
if [ -d ./$host ]; then
	proceed=""
	rsync -avn --chown=Link:Link ./$host/home/Link/ /home/Link/ | sed -e '/^sent .* bytes.*bytes\/sec$/d' -e '/^total size is/d'
	printf "${color}${host} home > home? (yes/no) : ${NC}"
	read proceed
	if [ "$proceed" = "yes" ]; then
		rsync -a --chown=Link:Link ./$host/home/Link/ /home/Link/
	fi
	proceed=""
	rsync -avn --chown=root:root --exclude="home" ./$host/ / | sed -e '/^sent .* bytes.*bytes\/sec$/d' -e '/^total size is/d'
	printf "${color}${host} root > root? (yes/no) : ${NC}"
	read proceed
	if [ "$proceed" = "yes" ]; then
		sudo rsync -a --chown=root:root --exclude="home" ./$host/ /
	fi
fi
