#!/usr/bin/python -O
#Mike Patrick Turner

"""
#Load appropriate version of python
module load Python/3.7.4-GCCcore-8.3.0 #Loads Python used for my environment
module load SciPy-bundle/2020.03-foss-2019b-Python-3.7.4 #Loads SciPy bundle containing pandas i.a.
"""

#libraries
import sys,os,gzip
import csv
import pandas as pd

sixtyK_dir = "./pop_structure/data/IMPUTE5_Output/60K_analyses"
input_file = str(sixtyK_dir + "/FIDs_IIDs_60K.txt")
output_file = str(sixtyK_dir + "/vcf_IIDs_60K.txt")

with open(output_file, "w") as newfile:
	header = "#IID\n"
	newfile.write(header)

with open(input_file) as iids:
	iids.next() #skip header
	for line in iids:
		LINE = line.split()
		newline = "_".join(LINE)
		with open(output_file, "a") as newfile:
			newfile.write(newline)
			newfile.write("\n")
		

