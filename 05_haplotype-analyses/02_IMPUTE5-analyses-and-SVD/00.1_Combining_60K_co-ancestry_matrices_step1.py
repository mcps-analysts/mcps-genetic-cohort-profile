#!/usr/bin/python -O
#Mike Patrick Turner

"""
#Load appropriate version of python
module load Python/3.7.4-GCCcore-8.3.0 #Loads Python used for my environment
module load SciPy-bundle/2020.03-foss-2019b-Python-3.7.4 #Loads SciPy bundle containing pandas i.a.
"""

	##This file takes a per-haplotype co-ancestry matrix and condenses it into a per-individula co-ancestry matrix##

#libraries
import sys,os,gzip
import csv
import pandas as pd
import numpy as np

tranche_num = sys.argv[2]

data_dir = str("./pop_structure/data/IMPUTE5_Output/60K_analyses/Tranche" + str(tranche_num))

inFile = sys.argv[1]

file_string = str(inFile)
file_list = file_string.split("/")
file_name = file_list[-1]

output_step1 = str(data_dir + "/compressed/comp_" + str(file_name))

with open(inFile) as matrix_fileb:
	Measure = matrix_fileb.readline()
	measure = Measure.split()
	for i in range(len(measure)):
		newlineb = []
		a = matrix_fileb.readline()
		if len(a) == 0:
			break
		b = matrix_fileb.readline()
		A = a.split()
		B = b.split()
		for j in range(3, len(A), 2):
			entry = float(A[j]) + float(A[j+1]) + float(B[j]) + float(B[j+1])
			newlineb.append(str(entry))
		NEWLINE = " ".join(newlineb)
		with open(output_step1, "a") as output_1:
			output_1.write(NEWLINE)
			output_1.write("\n")

print(str(file_name) + " condensed!")
