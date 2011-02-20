#!/bin/bash

function print_help {
cat << EOF
-n zlokalizuj, ale nie wykonuj skryptu
-l - wypisz liste znanych lokalizacji
-l NAZWA - wypisz sieci zapisane w lokalizacji NAZWA
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

function read_locations {
	index=0
	while read line
	do
		if [ -n "`echo $line | grep LOCATION`" ]; then
			Locations[$index]=`echo $line | sed -e "s/LOCATION \(.*\)$/\1/g"`
			let index=$index+1
		fi
	done < ".location.rc"
}

function read_cfg {
	found=0
	while read line
	do
		if [ -n "`echo $line | grep LOCATION`" ]; then
			if [ "$line" == "LOCATION $location_name" ]; then
				found=1
			else
				found=0
			fi
		fi

		if [[ $found -eq 1 && "`echo $line | grep LOCATION`" == "" ]]; then
			echo $line
		fi
	done < ".location.rc"
}

function remove_location {
	found=0
        while read line
        do
                if [ -n "`echo $line | grep LOCATION`" ]; then
                        if [ "$line" == "LOCATION $location_name" ]; then
                                found=1
                        else
                                found=0
                        fi  
                fi  

                if [[ $found -eq 0 ]]; then
                        `echo $line >> .location_new.rc`
                fi  
        done < ".location.rc"

	`rm .location.rc`
	`mv .location_new.rc .location.rc`
}

function localize {
	max_matches=0
	best_name="UNKNOWN"
        
	while read line
        do
                if [ -n "`echo $line | grep LOCATION`" ]; then
			if [[ $curr_matches -gt $best_matches ]]; then
				best_name=$curr_name
				best_matches=$curr_matches
			fi

                        curr_name=`echo $line | sed -e "s/LOCATION \(.*\)$/\1/g"`
                	curr_matches=0
		fi

		for index in ${!Addresses[*]} 
		do
			if [ "$line" == "${Addresses[$index]} ${Essids[$index]}" ]; then
				let curr_matches=$curr_matches+1
			fi
		done         

	done < ".location.rc"

	if [[ $curr_matches -gt $best_matches ]]; then
                best_name=$curr_name
                best_matches=$curr_matches
        fi 	

	echo "$best_name (with $best_matches matches)"
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

declare -a Loccations
declare -a Addresses
declare -a Essids


if [ $1 = '-l' ]; then
	if [ "$2" != "" ]; then
		location_name=$2
		read_cfg
	else	
	        read_locations
	
	        for name in ${Locations[@]}
	        do
	                echo $name
	        done
	fi
	exit 0
elif [[ $1 == '-r' && "$2" != "" ]]; then
	location_name=$2
	remove_location
	exit 0
fi

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

if [ $1 = '-a' -a "$2" != "" ]; then
	location_name=$2;
	add
elif [ $1 = '-n' ]; then
	localize
fi

