#!/bin/sh

sleeptime=0.5
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
		touch "$FLAGDIR/switch_A.flag" 
		/bin/sleep $sleeptime
		touch "$FLAGDIR/switch_B.flag"
		/bin/sleep $sleeptime
		touch "$FLAGDIR/switch_C.flag"
		/bin/sleep $sleeptime
		;;
	OFF|off)
		rm -f "$FLAGDIR/switch_A.flag"
		/bin/sleep $sleeptime
		rm -f "$FLAGDIR/switch_B.flag"
		/bin/sleep $sleeptime
		rm -f "$FLAGDIR/switch_C.flag"
		/bin/sleep $sleeptime
		;;
	*)
		usage
		exit 1
		;;
esac

exit 0
