#!/bin/sh

timestamp=$(date +%Y-%m)
if [ "$OSTYPE" = "cygwin" ]; then
	prefix="/usr/bin/"
else
	prefix=""
fi
${prefix}rsync -am --no-o --no-g --no-super --delete rsync://10.8.0.1/irclogs/Freenode/*-${timestamp}.log ~/irclogs/Freenode/
