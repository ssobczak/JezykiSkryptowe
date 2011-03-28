#! /usr/bin/env python

import sys, os
sys.path.append(os.path.expandvars('$HOME/lib'))

import argparse, re, math

def read_matrix(data, m, n):
	ret = []
	for i in range(n):
		row = []
		for j in range(m):
			try:
				row.append(float(data[i*m + j]))
			except ValueError:
				print "Blad! '" + data[i*m + j] + "' nie jest liczba!"
				sys.exit()
		ret.append(row)
	return ret

# sumowanie macierzy
def add(a, b): return a+b
def list_add(a, b): return map(add, a, b)

# odejmowanie macierzy
def sub(a, b): return a-b
def list_sub(a, b): return map(sub, a, b)

# mnozenie macierzy
def get_column(mat, c): return [x[c] for x in mat]
def mul(a, b): return a*b
def row_col_mul(row, col): return reduce(add, map(mul, row, col))
def matrix_mul(a, b): 
	return [[row_col_mul(a[row], get_column(b, col)) for col in range(len(a[row]))] for row in range(len(a))]

# wypisywanie z formatowaniem
def matrix_cell_max_len(m): return max([len('{0}'.format(m[row][col])) for row in range(len(m)) for col in range(len(m[0]))])
def print_matrix(m):
	for row in m:
		print ['{0:{1}}'.format(x, matrix_cell_max_len(m)) for x in row]
	print ''

parser = argparse.ArgumentParser(description='Oblicza sume, roznice i iloczyn dwoch macierzy (o ile to mozliwe). ' +
	'Macierze sa czytane z STDIN. Program ladnie formatuje wypisywane wyniki')
parser.add_argument('M1', nargs=1, type=int, help='Liczba kolumn pierwszej macierzy')
parser.add_argument('N1', nargs=1, type=int, help='Liczba wierszy pierwszej macierzy')
parser.add_argument('M2', nargs=1, type=int, help='Liczba kolumn drugiej macierzy')
parser.add_argument('N2', nargs=1, type=int, help='Liczba wierszy drugiej macierzy')
args = parser.parse_args()

m1, n1, m2, n2 = args.M1[0], args.N1[0], args.M2[0], args.N2[0]
data = re.findall(r'\S+', sys.stdin.read())

A = read_matrix(data[:m1*n1], m1, n1)
B = read_matrix(data[m1*n1:], m2, n2)

if m1 == m2 and n1 == n2:
	print "A + B"
	print_matrix(map(list_add, A, B))
	print "A - B"
	print_matrix(map(list_sub, A, B))

if m1 == n2:
	print "A x B"
	print_matrix(matrix_mul(A, B))

