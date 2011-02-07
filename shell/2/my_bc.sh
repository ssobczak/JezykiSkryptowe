#!/bin/sh

if [ $# != 1 ]; then
  cat << EOF
Brak parametru! 
Skrypt wykona obliczenia przekazane w parametrze z dokładnością do 308 miejsc po przecinku
i zwróci wynik bez nieznaczącyh zer po przecinku.
EOF
  exit 1;
fi;

calc=`cat << EOF

define trim(x) {
  tmp = x;
  while (tmp == x && scale > 0) {
    scale = scale-1;
    tmp = x/1;
  }
  scale = scale+1;
  return (x/1);
}

scale=308;
trim($1);

EOF`

echo "$calc" | bc

exit $?
