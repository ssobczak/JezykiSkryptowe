#!/usr/bin/perl -w

use strict;
use warnings;

use Getopt::Long;

require Tweet;

my $user = ''; 
my $max = 10; 
my $help = ''; 
    
GetOptions('u=s' => \$user, 'm=s' => \$max, 'h|help' => \$help);

if ($help eq '1')
{
	Tweet::print_help();
	exit 0;
}

if ($max !~ /^\d*$/)
{
	print "$max nie jest liczba!\nParametr -m musi byc liczba\n\n";
	Tweet::print_help();
	exit 0;
}

if ($user eq '')
{
	print "Parametr -u username jest obowiazkowy!\n\n";
	Tweet::print_help();
	exit 0;
}

my $content = Tweet::read_tweets($user);
my @tweets = Tweet::parse_messages($content);
my @times = Tweet::parse_times($content);

if ($max >= $#tweets)
{
	print "Wybrano $max tweetow do wyswietlenia, ale dostepnych jest tylko $#tweets.\n";
	print "Wyswietlam $#tweets tweetow.\n\n";

	$max = $#tweets;
}

foreach my $ind (0..$max-1) 
{
	print "$times[$ind] - $tweets[$ind]\n";
}
