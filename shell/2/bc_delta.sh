#!/bin/sh

if [ $# != 3 ]; then
  echo Aby obliczyc rownanie Ax^2 + Bx + C podaj A, B i C.
  exit 1;
fi

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

delta=$2*$2-4*$1*$3;

if (delta < 0) "Delta < 0 - brak rozwiazan\n";
if (delta == 0) {
  "Delta == 0 - jedno rozwiazanie. x = ";
  trim(-$2/2*$1);
}
if (delta > 0) {
  "Delta > 0 - Dwa rozwiazania.\n";
  "X1 = "; trim((-$2-sqrt(delta))/(2*$1));
  "X2 = "; trim((-$2+sqrt(delta))/(2*$1));
}

EOF`

echo "$calc" | bc -l

exit $?
