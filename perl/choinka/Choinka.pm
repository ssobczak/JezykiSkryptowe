#!/usr/bin/perl -w

use strict;
use warnings;

use HTTP::Daemon;
use HTTP::Status;

package Choinka;

sub print_help 
{
	print "Choinkowy serwer HTTP.\n";
	print "Serwer obsluguje naglowki HTTP 1.0, zalecane testowanie przegladarka internetowa!\n\n";
	print "Mozliwe opcje:\n";
	print "-p [PORT] Port do nasluchiwania (domyslnie 80)\n";
	print "-s [FILE] Plik stanu (domyslnie .statefile)\n";
	print "-c [NUMER] Numer serwowanej choinki [0-2]\n";
	exit;
}

sub read_state
{
	if(-f $_[0])
	{
		open(STATEFILE, $_[0]) or die "Niu mozna otworzyc pliku " . $_[0] . " !";
		my @file = <STATEFILE>;
		close(STATEFILE);	
		return $file[0];
	}
	else
	{
		return 0;
	}
}

sub save_state
{
	open(STATEFILE, ">".$_[0]) or die "Nie mozna zapisac statusu do pliku!";
	print STATEFILE $_[1];
	close(STATEFILE);
}

sub listen_forever
{
	my $deamon;
	my $state = read_state($_[2]);

	if ($deamon = new HTTP::Daemon LocalPort => $_[0])
	{
		print "Serwer uruchomiony na ", $deamon->url, "\n";
	} 
	else 
	{
		print "Nie mozna uruchomic serwera na porcie ", $_[0], "!\n";
		exit;
	}


	while (my $conn = $deamon->accept) 
	{
		while (my $request = $conn->get_request) 
		{
			$state = $state + 1;
			save_state($_[2], $state);

			print "Zapytanie $state:\n";
			print $request->header('user_agent'), " zarzadal ", $request->uri, "\n";
			$conn->send_file_response($_[1]);
      		}
      		$conn->close;
  	}
}

1;
