# separate machineconfig home and root backup
# make output prettier
rsync -avn --chown=Link:Link --delete --files-from="include" --exclude-from="exclude" --delete-excluded /home/ ./home/ | sed -e '/^sent .* bytes.*bytes\/sec$/d' -e '/^total size is/d'
echo "home to global home?"
echo "Type yes to continue" && read proceed
if [ "$proceed" = "yes" ]; then
	rsync -a --ignore-missing-args --chown=Link:Link  --delete --files-from="include" --exclude-from="exclude" --delete-excluded /home/ ./home/
fi
proceed=""
host="$(hostnamectl status --static)"
rsync -avn --delete --exclude-from="exclude" --files-from="machineconfig" / ./$host/ | sed -e '/^sent .* bytes.*bytes\/sec$/d' -e '/^total size is/d'
echo "root to $host root backup?"
echo "Type yes to continue" && read proceed
if [ "$proceed" = "yes" ]; then
	rsync -a --delete --exclude-from="exclude" --files-from="machineconfig" / ./$host/
fi
