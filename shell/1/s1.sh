#!/bin/bash

function print_help {
cat << EOF
Ahuku application.
Super cool help message!
EOF
}

for param in $* 
do
	if [ $param = '-h' -o $param = '--help' ] 
	then 
		print_help
		exit 0
	fi
done

for param in $*
do
	case $param in 
	-q | --quiet)
		exit 0;;
	*)
		echo Unknown parameters!
		print_help
		exit 1;;
	esac	
done

echo Akuku!
