#!/bin/bash

HOME="/var/lib/homebridge"
CMD="openmilight"
SEND="$HOME/bin/$CMD"
LOGDIR="$HOME/logs"
LOGFILE="$LOGDIR/led.log"
FLAGDIR="$HOME/flags"
DATE=`date +"%y-%m-%d %H:%M:%S"`

sleeptime=0.7
nRepeatTransmit=10

# functions
debug="ON"
log_entry() {
	if [ $debug == "ON" ]; then
		if [ -z "$4" ]; then 
			echo "[ $DATE ][$3] LED $1 $2" >> $LOGFILE 
		else
			echo "[ $DATE ][$3] LED $1 $2 - $4" >> $LOGFILE 
		fi
	fi
}

usage() {
	echo "USAGE: $0 <1|2|3|control|CONTROL> <on|ON|off|OFF>" 
}

# main
if [ $# -ne 2 ]; then
	usage
	exit 1
fi

log_entry $1 $2 "START"

case $1 in
	1) 
		let b=1 
		state="$FLAGDIR/led_1.flag"	
		;;
	2) 
		let b=2 
		state="$FLAGDIR/led_2.flag"	
		;;
   3) 
		let b=3
		state="$FLAGDIR/led_3.flag"	
		;;
	CONTROL|control)
		let b=0
		state="$FLAGDIR/led_c.flag"	
		;;
	*) 
		let b=-1
		usage
		exit 1
		;;
esac

case $2 in
	on|ON) 
		let k=2*$b+1 
		flag_cmd="touch"
		;;
	off|OFF) 
		let k=2*$b+2 
		flag_cmd="rm -f"
		;;	
	*) let k=-1
		usage
		exit 1
		;;
esac


b="c$b"
k="0$k"
log_entry $1 $2 "PARAM" "paramter: $b $k"

# Check if another Task is running
timeout=20
log_entry $1 $2 "PGREP"

while /usr/bin/pgrep -x "$CMD" > /dev/null ;
do
	# When the timeout is equal to zero, show an error and leave the loop.
	if [ "$timeout" == 0 ]; then
		echo "ERROR: Timeout while waiting for the process $CMD"
		log_entry $1 $2 "ERROR" "Timeout while waiting for the process $CMD" 
		sudo killall $CMD
		log_entry $1 $2 "ERROR" "kill all old processes of $CMD" 
                exit 1
	fi

	sleep 0.1
	# Decrease the timeout of one
	((timeout--))
	log_entry $1 $2 "WAIT" "Timeout ${timeout}00 ms" 
done

log_entry $1 $2 "SEND" "-----> ----> ---->"
sleep 0.2 
sudo ${SEND} -q 6F -r 6E -c 4F -b $b -k $k -v CD -n $nRepeatTransmit

log_entry $1 $2 "FLAG" "execute $flag_cmd $state"
$flag_cmd $state

if [ $1 == "CONTROL" ] || [ $1 == "control" ]; then
	echo "control"
	rm -f "$FLAGDIR/led_1.flag"
	sleep $sleeptime
	rm -f "$FLAGDIR/led_2.flag"
	sleep $sleeptime
	rm -f "$FLAGDIR/led_3.flag"
fi

log_entry $1 $2 "END" "----------------------------"

exit 0
