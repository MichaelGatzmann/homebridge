#!/bin/bash

HOME="/var/lib/homebridge"
CMD="codesend"
SEND="$HOME/bin/$CMD"
LOGDIR="$HOME/logs"
LOGFILE="$LOGDIR/rcswitch.log"
FLAGDIR="$HOME/flags"
DATE=`date +"%y-%m-%d %H:%M:%S"`

protocol=0
pulselength=0
nRepeatTransmit=10

# functions
debug="OFF"
log_entry() {
   if [ $debug == "ON" ]; then
      if [ -z "$4" ]; then
         echo "[ $DATE ][$3] SWITCH $1 $2" >> $LOGFILE
      else
         echo "[ $DATE ][$3] SWITCH $1 $2 - $4" >> $LOGFILE
      fi
   fi
}

usage() {
	echo "USAGE: $0 <a|A|b|B|c|C> <on|ON|off|OFF>" 
}

# main
if [ $# -ne 2 ]; then
	usage
	exit 1
fi

log_entry $1 $2 "START"

case $1 in
	a|A) 
		let code=345425
		state="$FLAGDIR/switch_A.flag"	
		;;
	b|B) 
		let code=348497
		state="$FLAGDIR/switch_B.flag"	
		;;
   c|C) 
		let code=349265
		state="$FLAGDIR/switch_C.flag"	
		;;
	*) 
		let code=-1
		usage 
		exit 1
		;;
esac

case $2 in
	on|ON) 
		flag_cmd="touch"
		let action=0
		;;
	off|OFF) 
		let action=3
		flag_cmd="rm -f"
		;;
	*) 
		let action=-1
		usage 
		exit 1
		;;
esac

let "code=$code+$action"
log_entry $1 $2 "CODE" "digitalcode: ${code}"

# Check if another Task is running
timeout=20
log_entry $1 $2 "PGREP"

while /usr/bin/pgrep -x "$CMD" > /dev/null ;
do
	# When the timeout is equal to zero, show an error and leave the loop.
	if [ "$timeout" == 0 ]; then
		echo "ERROR: Timeout while waiting for the process $CMD"
		log_entry $1 $2 "ERROR" "Timeout while waiting for the process $CMD"
	exit 1
	fi

	sleep 0.1
	# Decrease the timeout of one
	((timeout--))
	log_entry $1 $2 "WAIT" "Timeout ${timeout}0 ms"
done

log_entry $1 $2 "SEND" "-----> ----> ---->"
${SEND} $code $protocol $pulselength $nRepeatTransmit

log_entry $1 $2 "FLAG" "execute $flag_cmd $state"
$flag_cmd $state

log_entry $1 $2 "END" "----------------------------"

exit 0
