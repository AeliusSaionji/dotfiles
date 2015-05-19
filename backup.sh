# separate machineconfig home and root backup
NC='\033[0m' # No Color
color='\033[1;35m'
rsync -avn --chown=Link:Link --delete --files-from="include" --exclude-from="exclude" --delete-excluded /home/ ./home/ | sed -e '/^sent .* bytes.*bytes\/sec$/d' -e '/^total size is/d'
printf "${color}home > global home backup? (yes/no) : ${NC}"
read proceed
if [ "$proceed" = "yes" ]; then
	rsync -a --ignore-missing-args --chown=Link:Link  --delete --files-from="include" --exclude-from="exclude" --delete-excluded /home/ ./home/
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
