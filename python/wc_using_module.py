#! /usr/bin/env python

import sys, os
sys.path.append(os.path.expandvars('$HOME/lib'))

import argparse, wc_module

parser = argparse.ArgumentParser(description='Odpowiednik wc z mozliwoscia zliczania liczb.')
parser.add_argument('-l', action='store_true', help='Zlicz linie')
parser.add_argument('-w', action='store_true', help='Zlicz slowa')
parser.add_argument('-i', action='store_true', help='Zlicz liczby')
parser.add_argument('-c', action='store_true', help='Zlicz znaki')
parser.add_argument('files', metavar='FILE', nargs='+', type=file, help='Plik do przetworzenia')

args = parser.parse_args()

if args.l == args.w == args.i == args.c == False:
 args.l = args.w = args.c = True

found_l, found_w, found_c, found_i = wc_module.count_lwci(args.files)

if args.l: print "linii: {0}".format(found_l)
if args.w: print "wyrazow: {0}".format(found_w)
if args.i: print "liczb: {0}".format(found_i)
if args.c: print "znakow: {0}".format(found_c)

