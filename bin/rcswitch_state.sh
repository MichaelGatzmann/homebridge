#!/bin/bash

HOME="/var/lib/homebridge"
FLAGDIR="$HOME/flags"

if [ -e "$FLAGDIR/switch_A.flag" ] || \
	[ -e "$FLAGDIR/switchB.flag" ] || \
	[ -e "$FLAGDIR/switchC.flag" ] 
then
	echo "true"
else
	echo "false"
fi

exit 0
