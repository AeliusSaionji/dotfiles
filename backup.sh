rsync -avhP --chown=Link:Link --log-file="/home/Link/changes" --delete --files-from="include" --exclude-from="exclude" --delete-excluded /home/ ./home/
host="$(hostnamectl status --static)"
rsync -avhP --delete --files-from="machineconfig" / ./$host/
