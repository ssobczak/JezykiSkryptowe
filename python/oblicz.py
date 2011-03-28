#! /usr/bin/env python

import sys, os
sys.path.append(os.path.expandvars('$HOME/lib'))

import argparse
import re

parser = argparse.ArgumentParser(description='Oblicza sumy x, x+y, y i x*y z podanych plikow. Pomija linie zaczynajace sie od #')
parser.add_argument('-x', nargs=1, type=int, required=True, help='Numer kolumny zawierajacej X')
parser.add_argument('-y', nargs=1, type=int, required=True, help='Numer kolumny zawierajacej Y')
parser.add_argument('files', metavar='FILE', nargs='+', type=file, help='Plik z danymi do przetworzenia')
args = parser.parse_args()

def read_line(line, x, y):
#	print 'read_line("{0}", {1}, {2})'.format(line[:-1], x, y)
	
	num = re.findall(r'\S+', line)
	
	try:
		return float(num[x]), float(num[y])
	except ValueError:
		print "Blad! ({0}, {1}) to nie liczby!".format(num[x], num[y])
		sys.exit()
	except IndexError:
		print "W pliku nie ma wystarczajacej liczby kolumn!"
		sys.exit()

x_sum = x2_sum = y_sum = xy_sum = 0

for file in args.files:
	for line in file:
		if line[0] != '#':
			x, y = read_line(line, args.x[0], args.y[0])
			x_sum, x2_sum, y_sum, xy_sum = x_sum+x, x2_sum+x*x, y_sum+y, xy_sum+x*y

print "Suma x  : {0}\nsuma x^2: {1}\nsuma y  : {2}\nsuma x*y: {3}".format(x_sum, x2_sum, y_sum, xy_sum) 
