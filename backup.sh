# separate machineconfig home and root backup
# read -p, does it color?
color='\033[1;35m'
NC='\033[0m' # No Color
# the following is depreciated, back up all machines then remove it in favor of symlinking
rsync -aLvn --chown=Link:Link --delete --files-from="include" --exclude-from="exclude" --delete-excluded /home/ ./home/ | sed -e '/^sent .* bytes.*bytes\/sec$/d' -e '/^total size is/d'
printf "${color}home > global home backup? (yes/no) : ${NC}"
read proceed
if [ "$proceed" = "yes" ]; then
	rsync -aL --ignore-missing-args --chown=Link:Link  --delete --files-from="include" --exclude-from="exclude" --delete-excluded /home/ ./home/
fi
proceed=""
host="$(hostnamectl status --static)"
rsync -avn --delete --exclude-from="exclude" --files-from="machineconfig" / ./$host/ | sed -e '/^sent .* bytes.*bytes\/sec$/d' -e '/^total size is/d'
printf "${color}root > ${host} root backup? (yes/no) : ${NC}"
echo "root to $host root backup?"
read proceed
if [ "$proceed" = "yes" ]; then
	rsync -a --delete --exclude-from="exclude" --files-from="machineconfig" / ./$host/
fi
