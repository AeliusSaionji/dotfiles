#!/bin/sh

timestamp=$(date +%Y-%m)
/usr/bin/rsync -am --no-o --no-g --no-super --delete rsync://10.8.0.1/irclogs/Freenode/*-${timestamp}.log ~/irclogs/Freenode/
