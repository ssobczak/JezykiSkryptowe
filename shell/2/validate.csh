#!/bin/csh

if ($#argv != 1) then 
  echo Brakujący parametr. Skrypt sprawdzi, czy podany parametr jest liczbą. 
  exit 1
endif

set var=`echo $1 | gawk '/^-?[0-9]*(\.?[0-9]+)?([eEdDqQ]-?[0-9]+)?$/'`

if ( "$var" == "" ) then
  exit 1
endif 

echo $1 | sed 's/[eEqQdD]/*10^/g;s/ /*/'

