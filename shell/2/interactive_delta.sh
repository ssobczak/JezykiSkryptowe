#!/bin/bash

echo 'Aby rozwiazac rownanie Ax^2 + Bx + C = 0 podaj A, B i C'

function validate() {
  if [ -z `echo $1 | gawk '/^-?[0-9]*(\.?[0-9]+)?([eEdDqQ]-?[0-9]+)?$/'` ]; then  
    echo "Parametr $1 nie jest liczba!" 
    RETURN="ERROR"
  else
    RETURN=`echo $1 | sed 's/[eEqQdD]/*10^/g;s/ /*/'`
  fi
}

function read_num() {
  read var
  validate $var
  while [ "$RETURN" == "ERROR" ]; do
    echo Sproboj ponownie.
    read var
    validate $var;
  done
}

echo Podaj A
read_num
A=$RETURN
echo Podaj B
read_num
B=$RETURN
echo Podaj C
read_num
C=$RETURN

echo "A=$A   B=$B   C=$C"

delta=`./my_bc.sh "$B*$B-4*$A*$C"`

if [ ${delta:0:1} = '-' ]; then
	echo 'delta < 0 - brak rozwiazan rzeczywistych'
elif [ "$delta" = "0" -o "$delta" = "0.0" ]; then	
  x=`./my_bc "-$B/(2*$A)"`
	echo 'delta = 0 - dwa rowne pierwiastki'
  echo "x1 = x2 = $x"
else
  x1=`./my_bc.sh "(-$B-sqrt($delta))/(2*$A)"`
  x2=`./my_bc.sh "(-$B+sqrt($delta))/(2*$A)"`
	echo 'delta > 0 - dwa rozne pierwiastki'
  echo "x1 = $x1"
  echo "x2 = $x2"
fi

exit 0
