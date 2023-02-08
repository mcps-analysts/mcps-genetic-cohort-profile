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
import numpy as np

data_dir = str("./pop_structure/data/IMPUTE5_Output/60K_analyses/") 

input1 = str(data_dir + "MT_MCPS_60K_IIDs.txt")
Output = str(data_dir + "MT_MCPS_60K_FID_IID.txt")

with open(Output, "w") as IID_file:
	IID_file.write("#FID IID")
with open(Output, "a") as IID_file:
	IID_file.write("\n")


counter = 0

with open(input1) as gen_header:
	for line in gen_header:
		line = line.strip()
		if line[0] == "#":
			continue
		if line[-1] == "P":
			IID = line[-33:]
			counter += 1
		else:					
			IID = line[-29:]
		if line[0] == "F":
			LINE = line.split("_")
			FID = LINE[0]
		else:
			FID = IID
		entry_list = [FID, IID]
		entry = " ".join(entry_list)
		with open(Output, "a") as IID_file:
			IID_file.write(entry)
			IID_file.write("\n")

print(counter)
