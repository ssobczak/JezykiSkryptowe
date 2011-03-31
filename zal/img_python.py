#! /usr/bin/env python

import sys, os
sys.path.append(os.path.expandvars('$HOME/lib'))

import argparse
from img_module import *

parser = argparse.ArgumentParser(description='''
	Skrypt wrzucajacy obrazki typu gif, jpg, bmp i png 
	na serwer http://freeimagehosting.net i zwracajcy bezpoisrednie linki do nich.
	W przypadku bledow transfer kazdego z plikow jest ponawiany piec razy
''')
group = parser.add_mutually_exclusive_group(required=True)
group.add_argument('-d', nargs=1, help='Wyslij wszystkie pliki gif, jpg, bmp i png z podanego katalogu', metavar='DIRECTORY')
group.add_argument('-f', nargs='+', help='Wyslij wymienione pliki', metavar='FILE')

args = parser.parse_args()

if args.d != None:
	files = list_images(abspath(args.d[0]))
else:
	files = [abspath(f) for f in args.f]

print 'Wysylanie %d obrazkow.' % len(files)

for file in files:
	for i in range(5):
		if i > 0: print 'Ponawiam...'
		if assert_upload(file): break
