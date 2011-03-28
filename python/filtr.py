#! /usr/bin/env python

import sys, os
sys.path.append(os.path.expandvars('$HOME/lib'))

import argparse

parser = argparse.ArgumentParser(description='Usuwa linie zaczynajace sie od #')
group = parser.add_mutually_exclusive_group(required=True)
group.add_argument('-c', '--commandline', action='store_true', help='Przetwarza tekst z linii komend')
group.add_argument('-f', '--files', nargs='+', type=file, help='Przetwarza tekst z podanych plikow')
args = parser.parse_args()

def handle_file(file):
	for line in file:
		if line[0] != '#':
			print line[:-1]

if args.commandline:
	handle_file(sys.stdin)
else:
	for file in args.files:
		print '### ' + file.name + ': ###'
		handle_file(file)
