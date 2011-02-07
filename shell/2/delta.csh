#!/bin/csh

if ( $# != 3 ) then
	echo 'Aby rozwiazac rownanie Ax^2 + Bx + C = 0 podaj A, B i C'
	exit 1
endif

set A=`./validate.csh $1`
if ($? == 1) then
  echo "$1 is not a number"
  exit 1
endif

set B=`./validate.csh $2`
if ($? == 1) then
   echo "$2 is not a number"
   exit 1
 endif

set C=`./validate.csh $3`
if ($? == 1) then
  echo "$3 is not a number"
   exit 1
endif

echo "A=$A B=$B C=$C"

set delta=`./my_bc.sh "$B*$B-4*$A*$C"`
echo "delta = $delta"

if ( "`expr substr $delta 1 1`" == "-" ) then
	echo 'delta < 0 - brak rozwiazan rzeczywistych'
else if ( "$delta" == "0" || "$delta" == "0.0" ) then	
  set x=`./my_bc.sh "-$B/(2*$A)"`
	echo 'delta = 0 - dwa rowne pierwiastki'
  echo "x1 = x2 = $x"
else
  set x1=`./my_bc.sh "(-$B-sqrt($delta))/(2*$A)"`
	set x2=`./my_bc.sh "(-$B+sqrt($delta))/(2*$A)"`
  echo 'delta > 0 - dwa rozne pierwiastki'
  echo x1 = $x1
  echo x2 = $x2
endif

exit 0
