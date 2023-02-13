#!/usr/bin/python -O
#Mike Patrick Turner

"""
#Load appropriate version of python
module load Python/3.7.4-GCCcore-8.3.0 #Loads Python used for my environment
module load SciPy-bundle/2020.03-foss-2019b-Python-3.7.4 #Loads SciPy bundle containing pandas i.a.
"""

	##This code sums two co-ancestry matrices - the holding matrix (which is a rolling sum of the previous chunks) and the next chunk##

#libraries
import sys,os,gzip
import csv
import pandas as pd
import numpy as np

tranche_num = sys.argv[2]

data_dir = str("./pop_structure/data/IMPUTE5_Output/60K_analyses/Tranche" + str(tranche_num) + "/") 

inFile = sys.argv[1]

#Step 2 adds condensed matrices into the master matrix#

FinalOutput = str(data_dir + "output/MT_60K_Tranche" + str(tranche_num) + "_summed_co-anc_matrix.txt")

step2_input1 = inFile
step2_input2 = str(data_dir + "holding/MT_60K_Tranche" + str(tranche_num) + "_summed_co-anc_matrix.txt")

with open(step2_input1) as addition_file:
	with open(step2_input2) as old_master:
		counter = 0
		while counter < 140000:
			a = addition_file.readline()
			if len(a) == 0:
				break	
			b = old_master.readline()
			A = a.split()
			B = b.split()
			newline_list = []
			for i in range(len(A)):
				entry = float(A[i]) + float(B[i])
				newline_list.append(str(entry))
			NEWLINE = " ".join(newline_list)
			with open(FinalOutput, "a") as new_master:
				new_master.write(NEWLINE)
				new_master.write("\n")
			counter += 1

print(str(inFile) + " added to Master Matrix!")
