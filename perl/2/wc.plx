#!/usr/bin/perl -w

foreach (@ARGV) { /^--help$/ and die "
Zlicza linie (-l), slowa (-w), liczby (-i) i znaki (-c). Domyslnie -l -w -c.
Podaj opcje i liste plikow do wczytania.

"; }

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
  open(FILE, $file) or die "Can't open file $file!\n";

  foreach (<FILE>) {
    foreach $word (split /\s+/, ) { 
      ++$words_cnt; 
      ++$nums_cnt if $word =~ /^-?[0-9]*(\.?[0-9]+)?([eEdDqQ]-?[0-9]+)?$/;
    }
    $chars_cnt += length;
  }
  
  print "File $file:\n";
  foreach (@params) {
    printf "Lines: $.\n" if $_ eq "l";
    printf "Words: $words_cnt\n" if $_ eq "w";
    printf "Numbers: $nums_cnt\n" if $_ eq "i";
    printf "Chars: $chars_cnt\n" if $_ eq "c";
  }

  undef $words_cnt;
  undef $nums_cnt;
  undef $chars_cnt;
  close(FILE);
}
