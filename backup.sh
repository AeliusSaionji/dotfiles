rsync -avhP --log-file="/home/Link/changes" --delete --files-from="include" --exclude-from="exclude" --delete-excluded / .
host="$(hostnamectl status --static)"
rsync -avhP --no-g --no-o --delete --files-from"machineconfig" / ./$host/
