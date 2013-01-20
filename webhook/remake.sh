#!/bin/bash

PORT=39832
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
		out=$(
			{
				cd "$DIR/.." &&
				git pull &&
				make clean generate publish
			} 2>&1
		)
		if [ $? -eq 0 ] ; then
			echo 'HTTP/1.1 200 OK'
		else
			echo 'HTTP/1.1 500 Internal Server Error'
			echo >&2 "$out" # log
		fi
		echo
		echo "$out"
	else
		echo 'HTTP/1.1 403 Forbidden'
		echo >&2 "Forbidden the request $request" # log
	fi |
	sed 's/$/\r/'
}

if [ $# -eq 0 ]; then
	listen
else 
	process
fi


