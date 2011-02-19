#!/bin/bash

function print_help {
cat << EOF
-l - wypisz liste znanych lokalizacji
-a NAZWA - zapisz aktualna lokalizacje jako NAZWA
-d NAZWA - usun lokalizacje
EOF
}

function add {
# check if exists
	`echo "LOCATION $location_name" >> .location.rc`

	for ind in `seq 0 $index`
	do	
		`echo "${Addresses[$ind]} ${Essids[$ind]}" >> .location.rc`
	done
}

function read {
	
}

for param in $* 
do
	if [ $param = '-h' -o $param = '--help' ] 
	then 
		print_help
		exit 0
	fi
done

if [ `whoami` !=  "root" ]; then
	echo "Uruchom program przez sudo, zeby miec uprawnienia do skanowania sieci!"
	exit 0
fi

declare -a Addresses
declare -a Essids

address=""
essid=""
index=0

while read line
do

	if [ -n "`echo $line | grep Address`" ]; then
		address=`echo $line | sed -e "s/^.*Address: \(.*\)$/\1/g"`
	elif [ -n "`echo $line | grep ESSID`" ]; then
		essid=`echo $line | sed -e "s/^.*ESSID:\"\(.*\)\".*$/\1/g"`
	fi

	if [ ${#address} -gt 0 -a ${#essid} -gt 0 ]; then
		Addresses[$index]=$address
		Essids[$index]=$essid

		let index=$index+1

		address=""
		essid=""
	fi

done < <(iwlist wlan1 scanning)

if [ $1 = '-a' -a -n $2 ]; then
	location_name=$2;
	add
fi
