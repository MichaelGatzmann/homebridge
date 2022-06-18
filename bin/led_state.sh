#!/bin/bash

HOME="/var/lib/homebridge"
FLAGDIR="$HOME/flags"

if [ -e "$FLAGDIR/led_1.flag" ] || \
	[ -e "$FLAGDIR/led_2.flag" ] || \
	[ -e "$FLAGDIR/led_3.flag" ] 
then
	echo "true"
else
	echo "false"
fi

exit 0
