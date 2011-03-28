#! /usr/bin/env python

import re

def is_number(w): return re.search(r'^-?[0-9]*(\.?[0-9]+)?([eEdDqQ]-?[0-9]+)?$', w) != None

def count_lwci(files) :
	l = w = c = i = 0

	for file in files:
		content = file.readlines()

		l += len(content)
		w += sum([len(re.findall(r'\S+', line)) for line in content])
		i += sum([len(filter(is_number, re.findall(r'\S+', line))) for line in content])
		c += sum([len(line) for line in content])

	return l, w, c, i

