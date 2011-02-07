#!/bin/csh

echo 'Aby rozwiazac rownanie Ax^2 + Bx + C = 0 podaj A:'
alias retry echo "To nie jest poprawna liczba. Sproboj ponownie."

set A=`./validate.csh $<`
while ($? == 1)
  retry
  set A=`./validate.csh $<`
end

echo "Podaj B:"
set B=`./validate.csh $<`
if ($? == 1) then
   retry
   set B=`./validate.csh $<`
 endif

echo "Podaj C:"
set C=`./validate.csh $<`
if ($? == 1) then
  retry
  set C=`./validate.csh $<`
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
