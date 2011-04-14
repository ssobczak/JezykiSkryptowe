#!/bin/bash

function validate() {
  if [ -z `echo $1 | gawk '/^[0-9]*$/'` ]; then  
    echo "Parametr $1 nie jest liczba!" 
    exit 0
  else
    RETURN=$1
  fi
}

function restore_state() {
	if [ -f $1 ]
	then
		RETURN=`cat $1`
	else
		RETURN=0
	fi
}

function serve() {
	RESP=/tmp/webresp
	[ -p $RESP ] || mkfifo $RESP

	while true ; do
		( cat $RESP ) | nc -l $PORT | (
			REQ=`while read L && [ " " "<" "$L" ] ; do echo "$L" ; done`
			echo "Zapytanie $COUNT: [`date '+%Y-%m-%d %H:%M:%S'`] $REQ" | head -1

			RESP_BODY=`gzip -c -d $CHOINKA`

			cat >$RESP <<EOF
			HTTP/1.0 200 OK
			Cache-Control: private
			Content-Type: text/html
			Server: bash http server
			Connection: Close
			Content-Length: ${#RESP_BODY}

			$RESP_BODY
EOF
		)
	
	COUNT=`expr $COUNT + 1`
	echo $COUNT > $STATEFILE
	done
}

PORT=80
STATEFILE=".statefile"
CHOINKA="choinka1"

for param in $* 
do
	if [ $param = '-h' -o $param = '--help' ] 
	then 
		echo "Choinkowy serwer HTTP."
		echo "Serwer obsluguje naglowki HTTP 1.0, zalecane testowanie przegladarka internetowa!"
		echo "Mozliwe opcje:"
		echo "-p [PORT] Port do nasluchiwania (domyslnie 80)"
		echo "-s [FILE] Plik stanu (domyslnie .statefile)"
		echo "-c [NUMER] Numer serwowanej choinki [0-2]"
		exit 0
	fi
done

while (( "$#" ))
do
	if [ $1 = "-p" ]
	then	
		shift
		validate $1
		PORT=$RETURN
	elif [ $1 = "-s" ]
	then
		shift
		STATEFILE=$1
	elif [ $1 = "-c" ]
	then
		shift
		validate $1
		CHOINKA="choinka$RETURN"
		if [ ! -f $CHOINKA ]
		then
			echo "Choinka numer $RETURN nie istnieje!"
			exit 0
		fi
	fi
	shift
done

restore_state $STATEFILE
COUNT=$RETURN

serve

