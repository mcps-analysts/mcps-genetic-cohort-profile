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

##This code creates a list of ambiguous SNPs for use in the 03 script##

data_dir = "./data/QC_datasets/60K_files/"

input = str(data_dir + "MT_MCPS_60K_MAF1pc.bim")
output = str(data_dir + "MT_60K_ambig_SNPs.txt")

with open(input) as SNPs:
	with open(output, "a") as ambiguous_rsIDs:
		for line in SNPs:
			LINE = line.split()
			if LINE[4] == "A" and LINE[5] == "T":
				ambiguous_rsIDs.write(LINE[1])
				ambiguous_rsIDs.write("\n")
			elif LINE[4] == "T" and LINE[5] == "A":
				ambiguous_rsIDs.write(LINE[1])
				ambiguous_rsIDs.write("\n")
			elif LINE[4] == "C" and LINE[5] == "G":
				ambiguous_rsIDs.write(LINE[1])
				ambiguous_rsIDs.write("\n")
			elif LINE[4] == "G" and LINE[5] == "C":
				ambiguous_rsIDs.write(LINE[1])
				ambiguous_rsIDs.write("\n")

print("Ambiguous rsID file created!")

