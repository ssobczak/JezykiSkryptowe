package Wc;

sub statFile {
  undef @params;
  foreach $i (1..$#_) {
    push(@params, $_[$i]);
  }

  open(FILE, $_[0]) or die "Can't open file ".$_[0]."!\n";

  foreach (<FILE>) {
    foreach $word (split /\s+/, ) { 
      ++$words_cnt; 
      ++$nums_cnt if $word =~ /^-?[0-9]*(\.?[0-9]+)?([eEdDqQ]-?[0-9]+)?$/;
    }
    $chars_cnt += length;
  }
  
  $ret = "File ".$_[0].":\n";
  foreach (@params) {
    $ret .= "Lines: $.\n" if $_ eq "l";
    $ret .= "Words: $words_cnt\n" if $_ eq "w";
    $ret .= "Numbers: $nums_cnt\n" if $_ eq "i";
    $ret .= "Chars: $chars_cnt\n" if $_ eq "c";
  }

  undef $words_cnt;
  undef $nums_cnt;
  undef $chars_cnt;
  close(FILE);

  return $ret;
}

1;
