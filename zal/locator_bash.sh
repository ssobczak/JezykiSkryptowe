#!/bin/bash

function print_help {
cat << EOF
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

address=""
essid=""

while read line
do

	if [ -n "`echo $line | grep Address`" ]; then
		address=`echo $line | sed -e "s/^.*Address: \(.*\)$/\1/g"`
	elif [ -n "`echo $line | grep ESSID`" ]; then
		essid=`echo $line | sed -e "s/^.*ESSID:\"\(.*\)\".*$/\1/g"`
	fi

	if [ ${#address} -gt 0 -a ${#essid} -gt 0 ]; then
		echo "address $address essid $essid"
		address=""
		essid=""
	fi

done < <(sudo iwlist wlan1 scanning)

