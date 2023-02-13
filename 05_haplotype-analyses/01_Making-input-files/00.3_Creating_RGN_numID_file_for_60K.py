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
RGN_key = str(sixtyK_dir + "/freeze_145k_id-key.csv")
output_file = str(sixtyK_dir + "/vcf_RGN_numID_60K.txt")

with open(output_file, "w") as newfile:
	header = "#IID\n"
	newfile.write(header)

IID_list = []

with open(input_file) as iids:
	next(iids)
	counter = 0 
	for line in iids:
		LINE = line.strip().split()
		if counter == 0:
			print(LINE[1])
			print(len(LINE[1]))
		IID_list.append(LINE[1])
		counter += 1
	print(str(counter) + " IIDs added to list.")

with open(RGN_key) as rgn_KY:
	counter = 0
	for line in rgn_KY:
		LINE = line.strip().split(",")
		if counter == 1:
			print(LINE[0])
			print(len(LINE[0]))
		if LINE[0] in IID_list:
			with open(output_file, "a") as newfile:
				newfile.write(LINE[2]+"\n")
			counter += 1
print(str(counter) + " numeric IDs written to file")


