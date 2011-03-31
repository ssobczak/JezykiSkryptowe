#! /usr/bin/env python

import sys, os
sys.path.append(os.path.expandvars('$HOME/lib'))

from os.path import abspath, basename, join

import random, string, re
import mimetypes, urllib2, httplib
import socket

def random_string (length):
    return ''.join (random.choice (string.letters) for ii in range (length + 1))

def encode_multipart_data (file):
    boundary = random_string (30)

    def get_content_type (filename):
        return mimetypes.guess_type (filename)[0] or 'application/octet-stream'

    def encode_file (filename):
        return ('--' + boundary,
                'Content-Disposition: form-data; name="attached"; filename="%s"' % (filename),
                'Content-Type: %s' % get_content_type(filename),
                '', open (filename, 'rb').read ())

    lines = []
    lines.extend (encode_file (file))
    lines.extend (('--%s--' % boundary, ''))
    body = '\r\n'.join (lines) 

    headers = {'content-type': 'multipart/form-data; boundary=' + boundary,
               'content-length': str (len (body))}

    return body, headers

def send_post (url, file):
    req = urllib2.Request (url)
    connection = httplib.HTTPConnection (req.get_host ())

    connection.request ('POST', req.get_selector (), *encode_multipart_data (file))
    return connection.getresponse ()

def upload(file):
    response = send_post('http://www.freeimagehosting.net/upload.php', file)
    match = re.search('\[img\]([^\[].*)\[/img\]', response.read())

    return string.replace(match.group(1), '/th.', '/')


def list_images(dir):
	def assert_slash(s) : 
		if s[-1] == '/': return s
		else: return s + '/'

	def is_image(file): 
		return file[-3:] in ['gif', 'jpg', 'bmp', 'png']

	return [assert_slash(dir) + img for img in filter(is_image, os.listdir(dir))]

def assert_upload(file):
	try:
		print 'Plik %s jest pod adresem %s' % (basename(file), upload(file))
		return True
	except socket.error:
		print 'Wysylanie pliku %s nie powiodlo sie.' % basename(file)
		return False

