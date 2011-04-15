#!/usr/bin/python

import socket, sys

if len(sys.argv) != 2:
	print "Podaj jeden parametr - numer portu serwera!"
	sys.exit()

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

sock.connect(('localhost', int(sys.argv[1])))

print sock.recv(4096)
sock.close()

