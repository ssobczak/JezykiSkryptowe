#!/usr/bin/perl -w

foreach (@ARGV) { /^--help$/ and die "
Zlicza linie (-l), slowa (-w), liczby (-i) i znaki (-c). Domyslnie -l -w -c.
Podaj opcje i liste plikow do wczytania.

"; }

use Wc;

my @params;
my @files;
foreach $param (@ARGV) { 
  $param =~ s/^-//g;
  if ($param =~ /^[lwci]$/) {
    push (@params, $param);
  } else {
    push (@files, $param);
  }
}

@params = ("l", "w", "c") if $#params < 0;

while ($file = shift(@files)) {
  print Wc::statFile($file, @params);
}
