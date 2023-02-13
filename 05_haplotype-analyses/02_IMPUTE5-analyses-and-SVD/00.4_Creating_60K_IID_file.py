#!/usr/bin/python -O
#Mike Patrick Turner

"""
#Load appropriate version of python
module load Python/3.7.4-GCCcore-8.3.0 #Loads Python used for my environment
"""

#libraries
import sys

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

