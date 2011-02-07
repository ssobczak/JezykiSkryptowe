#!/bin/bash

for base in "149.156.64." "149.156.70." "149.156.72." "149.156.90."; do
  for i in `seq 1 254`; do
    
    echo -n "$base$i "
    ping -c1 -w1 $base$i >& /dev/null
    if [ $? == 0 ]; then
      echo -n "PING "
    fi

    http=`echo -e "DUPA\r\n\r\n" | nc.traditional -w 1 $base$i 80 2>&1 | grep html`
    ssh=`nc -w 1  $base$i 22 | grep SSH`

    if [ 4 -lt ${#http} ]; then
      echo -n "HTTP "
    fi
   
    if [ 3 -lt ${#ssh} ]; then
      echo -n "SSH"
    fi

    echo 

  done
done
