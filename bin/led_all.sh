#!/bin/sh

sleeptime=0.8
HOME="/var/lib/homebridge"
FLAGDIR="$HOME/flags"


usage() {
        echo "USAGE: $0 <on|ON|off|OFF>" 
}

if [ $# -ne 1 ]; then
  usage
  exit 1
fi


case $1 in
	ON|on)
		touch "$FLAGDIR/led_1.flag" 
		/bin/sleep $sleeptime
		touch "$FLAGDIR/led_2.flag" 
		/bin/sleep $sleeptime
		touch "$FLAGDIR/led_3.flag" 
		/bin/sleep $sleeptime
		;;
	OFF|off)
		rm -f "$FLAGDIR/led_1.flag"
		/bin/sleep $sleeptime
		rm -f "$FLAGDIR/led_2.flag"
		/bin/sleep $sleeptime
		rm -f "$FLAGDIR/led_3.flag"
		/bin/sleep $sleeptime
		;;
	*)
		usage
		exit 1
		;;
esac

exit 0
