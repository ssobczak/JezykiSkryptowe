#!/usr/bin/perl -w

$#ARGV == 2 or die "Za malo liczb";

foreach $i (@ARGV) { 
  $i =~ /^-?[0-9]*(\.?[0-9]+)?([eEdDqQ]-?[0-9]+)?$/ or die "Argument $i nie jest liczba!"; 
  $i =~ s/[eEqQdD]/*10^/;
}

$delta = `echo $ARGV[1]*$ARGV[1] - 4*$ARGV[0]*$ARGV[2] | bc`;
$delta =~ s/\n//;
print "Delta: $delta\n";

if ($delta < 0) {
  print "Delta mniejsza od zera - brak rozwiazan.\n";
} elsif ($delta == 0) {
  $x = `echo "(-$ARGV[1])/(2*$ARGV[0])" | bc`;
  printf "Delta = 0 - jeden pierwiastek\nX = $x\n";
} else {
  $x1 = `echo "(-$ARGV[1]-sqrt($delta))/(2*$ARGV[0])" | bc`;
  $x2 = `echo "(-$ARGV[1]+sqrt($delta))/(2*$ARGV[0])" | bc`;
  printf "Delta > 0 - dwa pierwiastki\n X1 = $x1 X2 = $x2";
}
