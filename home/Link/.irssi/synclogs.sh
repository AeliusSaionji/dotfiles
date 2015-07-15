#!/bin/sh

timestamp=$(date +%Y-%m)
echo "/set autolog off" > ~/.irssi/remote-control
/usr/bin/rsync -am --no-o --no-g --no-super --delete rsync://25.18.109.202/irclogs/Freenode/*-${timestamp}.log ~/irclogs/Freenode/ && printf "logs synced\n" && echo "/set autolog on" > ~/.irssi/remote-control
