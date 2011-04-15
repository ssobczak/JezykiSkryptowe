#!/usr/bin/python

import sys, os
sys.path.append(os.path.expandvars('$HOME/lib'))

from SocketServer import BaseRequestHandler, TCPServer
from os.path import isfile

import socket, argparse, pickle

increment_counter = None
choinka = None

def make_increment_counter(filename):
	def read_state():
		try:
			state = open(filename, "r")
			counter = pickle.load(state)
			state.close()
		except IOError:
			counter = 0

		return counter
	
	def write_state(counter):
		state = open(filename, "w")
		pickle.dump(counter, state)
		state.close()

	def increment_counter():
		try:
			counter = read_state() + 1
			write_state(counter)
			return counter
		except IOError:
			print 'Nie mozna otworzyc pliku stanu %s' % filename
			sys.exit()

	return increment_counter

class ChtreeHandler(BaseRequestHandler):
	def handle(self):
		global incerment_counter, choinka
		print "Polaczenie numer %s z klientem %s" % (increment_counter(), self.client_address[0])
	
		self.request.sendall(choinka)
		self.request.close()

parser = argparse.ArgumentParser(description='Uruchamia serwer choinkowy ze zliczaniem ilosci zapytan')
parser.add_argument('-p', '--port', nargs=1, type=int, default=[8080],  help='Port na ktorym serwer bedzie sluchal')
parser.add_argument('-c', '--choinka', nargs=1, default=['choinka.txt'], help='Plik zawierajacy choinke')
parser.add_argument('-s', '--statefile', nargs=1, default=['.choinka-state'], help='Plik ze stanem serwera')

args = parser.parse_args()

try:
	choinka_src = open(args.choinka[0], "r")
	choinka = choinka_src.read()
	choinka_src.close()
except IOError:
	print "Nie mozna odczytac pliku z choinka: %s" % args.choinka[0]
	sys.exit()

try:
	increment_counter = make_increment_counter(args.statefile[0])
	print "Uruchamiam serwer na porcie %s" % args.port[0]
	TCPServer(('', args.port[0]), ChtreeHandler).serve_forever()
except socket.error:
	print "Inna kopia serwera jest juz uruchomiona."
	sys.exit()
