#!/usr/bin/perl -w

use strict;
use warnings;

use Getopt::Long;
use LWP::UserAgent;
use HTML::Parse;

sub print_help
{
	print "Program pobiera i wyswietla kilka ostatnich tweetow z konta podanego uzytkownika\n";
	print "Parametry:\n";
	print "-u username - nazwa konta, z którego pobrać tweety\n";
	print "-m LICZBA - pobierz maksymalnie LICZBA tweetów\n";
	exit;
}

my $user = ''; 
my $max = 10; 
my $help = ''; 
    
GetOptions('u=s' => \$user, 'm=s' => \$max, 'h|help' => \$help);

if ($help eq '1')
{
	print_help();
	exit 0;
}

if ($max !~ /^\d*$/)
{
	print "$max nie jest liczba!\nParametr -m musi byc liczba\n\n";
	print_help();
	exit 0;
}

if ($user eq '')
{
	print "Parametr -u username jest obowiazkowy!\n\n";
	print_help();
	exit 0;
}

my $ua = LWP::UserAgent->new;
$ua->agent("Perl commad line client");

my $url = "http://twitter.com/$user";

my $request = HTTP::Request->new(GET => $url);
my $response = $ua->request($request);

if (!$response->is_success)
{
	print "Blad wykonania zapytania!\n";

	my $errno = $response->code;
	my $msg = $response->message;

	print "Szczegoly bledu: blad numer $errno - $msg\n";
	exit 0;
}

# wybiera zawartość tagów <span class="entry-content"> </span>
my @tweets = $response->content =~ m{<span\ class="entry-content">(.*)</span>}gx;

# wybiera czasy spomiędzy tagów <span class="published timestamp"> </span>
my @times = $response->content =~ m{<span.*class="published\ timestamp"[^>]*>(.*)</span>}gx;

foreach my $ind (0..$#tweets) 
{
	# Zamienia linki z postaci <a href=...>TEKST</a> @TEKST@
	$tweets[$ind] =~ s/<a[^>]*>([^<]*)<\/a>/\@$1\@/g;
}

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
