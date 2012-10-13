#!/bin/bash

PORT=39832
KEY=`dirname $0`/key

DIR="`dirname $0`"

listen() {
	while true ; do
		nc -l -p $PORT -c "$0 -"
		sleep 1
	done
}

key() {
	cat "$DIR/key"
}

process() {
	read method request x
	sed -n '/^\r$/q'
	if [ "$method" = "POST" -a "$request" = "/`key`" ] ; then
		echo 'HTTP/1.1 200 OK'
		echo
		git pull &&
		make -C "$DIR/.." clean generate
	else
		echo 'HTTP/1.1 403 Forbidden'
	fi |
	sed 's/$/\r/'
}

if [ $# -eq 0 ]; then
	listen
else 
	process
fi


