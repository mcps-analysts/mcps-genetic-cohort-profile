#!/usr/bin/python -O
#Mike Patrick Turner

"""
#Load appropriate version of python
module load Python/3.7.4-GCCcore-8.3.0 #Loads Python used for my environment
module load SciPy-bundle/2020.03-foss-2019b-Python-3.7.4 #Loads SciPy bundle containing pandas i.a.
"""

	##This code sums two co-ancestry matrices - the holding matrix (which is a rolling sum of the previous chunks)##
	##and the next chunk##

#libraries
import sys,os,gzip
import csv
import pandas as pd
import numpy as np

data_dir = str("./pop_structure/data/IMPUTE5_Output/60K_analyses/") 

input1 = sys.argv[1]
Output = str(data_dir + "MT_MCPS_60K_IIDs.txt")

with open(Output, "w") as IID_file:
	IID_file.write("#IID")
with open(Output, "a") as IID_file:
	IID_file.write("\n")

with open(input1) as gen_header:
	head = gen_header.readline()
	HEAD = head.split()
	for iid in range(4, len(HEAD), 2):
		ID = HEAD[iid]
		entry = str(ID[0:-2])
		with open(Output, "a") as IID_file:
			IID_file.write(entry)
			IID_file.write("\n")

