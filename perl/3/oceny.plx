#!/usr/bin/perl -w

foreach (@ARGV) { /^--help$/ and die "
Liczy srednia ocen w plikach.
PARAMETRY: Nazwy plików
FORMAT PLIKÓW: nazwisko imie ocena

WYNIK: ocena zaokraglona do dozwolonych na UJ (2, 3, 3.5, 4, 4.5, 5)

Dozwolone bledy w pliku wejsciowym: wielokrotne biale znaki
Obsługa wielu niezależnych plików wejściowych
Globalna statystyka

"; }


my %global_scores;
my %global_cnt;

sub zaokraglij {
    $avg = $_[0];

    if ($avg < 2.5) { $avg = 2; }
    elsif ($avg < 3.25) { $avg = 3; }
    elsif ($avg < 3.75) { $avg = 3.5; }
    elsif ($avg < 4.25) { $avg = 4; }
    elsif ($avg < 4.75) { $avg = 4.5; }
    else { $avg = 5; }

  return $avg;
}

foreach $filename (@ARGV) {
  open(FILE, $filename) or die "Nie mozna otworzyc pliku $filename\n";

  print "=== $filename ===\n";

  my %scores;
  foreach $line (<FILE>) {
    chomp $line;
    $line =~ /(.*\s+.*)\s(.*)/ and $scores{$1} .= " $2";
  }

  foreach $key (sort(keys %scores)) {
    $scores{$key} =~ s/^ //g;
    $sum = 0; $count = 0;
    foreach $grade (split(/ /, $scores{$key})) {
      $count++;
      $global_cnt{$key}++;

      $sum += $grade;
      $global_scores{$key} += $grade;
    }

    $avg = zaokraglij($sum/$count);

    print "$key ".$scores{$key}." srednia: $avg\n";
  }
  undef %scores;
}
 
print "=== PODSUMOWANIE ===\n";
foreach $key (sort(keys %global_scores)) {
  print "$key: ".zaokraglij($global_scores{$key}/$global_cnt{$key})."\n";
}
