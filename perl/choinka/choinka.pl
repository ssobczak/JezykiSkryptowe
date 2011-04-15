#!/usr/bin/perl -w

use strict;
use warnings;

use Cwd 'abs_path';
use File::Basename;
use Getopt::Long;

require Choinka;

BEGIN { 
	 push @INC, dirname(abs_path($0));
}

my ($port, $choinka, $help, $state) = (80, 1, 0, ".statefile");

GetOptions('p|port=i' => \$port, 's|state=s' => \$state, 'c|choinka=i' => \$choinka, 'h|help' => \$help) or exit 0;

$help and Choinka::print_help() and exit 0;

Choinka::listen_forever($port, "choinka$choinka.txt", $state);
