#!/usr/bin/perl -w

use strict;
use warnings;

use LWP::UserAgent;
use HTML::Parse;

package Tweet;

sub print_help
{
        print "Program pobiera i wyswietla kilka ostatnich twittow z konta podanego uzytkownika\n";
        print "Tekst otoczony znakami '\@' w oryginale byl linkiem\n\n";
        print "Parametry:\n";
        print "-u username - nazwa konta, z którego pobrać tweety\n   np. parametr -u google pobierze twitty dodane przez Google\n";
        print "-m LICZBA - pobierz maksymalnie LICZBA tweetów\n   np. -m 3 pobierze tylko trzy najnowsze twitty\n";
        exit;
}

sub read_tweets
{
	my $ua = LWP::UserAgent->new;
	$ua->agent("Perl commad line client");

	my $url = "http://twitter.com/$_[0]";

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

	return $response->content;
}

sub parse_messages {
	# wybiera zawartość tagów <span class="entry-content"> </span>
	my @tweets = $_[0] =~ m{<span\ class="entry-content">(.*)</span>}gx;

	foreach my $ind (0..$#tweets) 
	{
		# Zamienia linki z postaci <a href=...>TEKST</a> @TEKST@
		$tweets[$ind] =~ s/<a[^>]*>([^<]*)<\/a>/\@$1\@/g;
	}

	return @tweets;
}

sub parse_times
{
	# wybiera czasy spomiędzy tagów <span class="published timestamp"> </span>
	return $_[0] =~ m{<span.*class="published\ timestamp"[^>]*>(.*)</span>}gx;
}


1;
