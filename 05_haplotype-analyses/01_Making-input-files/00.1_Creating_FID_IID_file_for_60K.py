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
input_file = str(sixtyK_dir + "/JT_IIDs_for_PCs.txt")
whole_cohort = "./imputed-topmed/mcps/geno_files/mcps.autosomes.fam"
output_file = str(sixtyK_dir + "/FIDs_IIDs_60K.txt")

with open(output_file, "w") as newfile:
	header = "#FID IID\n"
	newfile.write(header)

sixtyK_list = []

with open(input_file) as iids:
	for line in iids:
		sixtyK_list.append(line[:-1])

with open(whole_cohort) as cohort:
	counter = 0
	for line in cohort:
		b = line.split()
		if b[1] in sixtyK_list:
			newline = str(b[0] + " " + b[1])
			with open(output_file, "a") as newfile:
				newfile.write(newline+"\n")
			counter += 1		
print(counter)
