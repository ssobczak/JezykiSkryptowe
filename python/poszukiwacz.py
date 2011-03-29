#! /usr/bin/env python

import sys, os
sys.path.append(os.path.expandvars('$HOME/lib'))

import re

def print_help(): print """
Program wyszukuje i podaje statistyki wystapien podanych fraz w plikach.

PARAMETRY: [-h | --help] [OPCJA WARTOSC [OPCJA WARTOSC ...]]
 
OPCJA = '-d' oznacza, ze WARTOSC to sciezka do przeszukania
OPCJA = '-s' oznacza, ze WARTOSC to tekst, ktory ma byc wyszukany

-h | --help wypisuje ta wiadomosc i konczy program
"""

def read_args(args):
	if args.count('-h') > 0 or args.count('--help') > 0:
		print_help()
		sys.exit()

	if len(args) % 2 == 1:
		print "Nieparzysta ilosc parametrow, powinny one wystepowac parami!"
		sys.exit()
	
	strings = []
	dirs = []
	for no in range(len(args)/2):
		if args[2*no] == '-d':
			dirs.append(args[2*no+1])
		elif args[2*no] == '-s':
			strings.append(args[2*no+1])
		else:
			print "Oczekiwano '-s' lub '-d', otrzymano {0}".format(args[2+no])
			sys.exit()

	return strings, dirs

def dirs2files(dirs):
	def assert_slash(s) : 
		if s[-1] == '/': return s
		else: return s + '/'

	files = []
	for dir in dirs:
		files.extend([assert_slash(w[0])+filename for w in os.walk(dir) for filename in w[2]])
	return files

def analyze_files(files):
	counters = dict.fromkeys(strings, 0)
	for filename in files:
		try:
			file = open(filename, 'r')
			file_content = file.read()
		except IOError:
			print "Nie mozna odczytac pliku {0}!".format(filename)
			sys.exit()

		to_print = True	
		for string in strings:
			count = file_content.count(string)
			counters[string] += count

			if count > 0 and to_print:
				print filename
				to_print = False

	return counters

strings, dirs = read_args(sys.argv[1:])
files = dirs2files(dirs)

print "Pliki zawierajace szukane slowa:"
counters = analyze_files(files)

print "\nLiczba wystapien:"
for word in counters.keys():
	print "{0}: {1}".format(word, counters[word])

