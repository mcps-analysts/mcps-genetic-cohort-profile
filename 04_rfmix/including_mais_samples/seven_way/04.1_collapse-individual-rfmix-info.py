#!/usr/bin/python -O
# Jason Matthew Torres
'''
Usage:
module load Python/3.7.4-GCCcore-8.3.0
source python/projectA-ivybridge/bin/activate
python 04.1_collapse-individual-rfmix-info.py
'''
# libraries
import sys, os
import subprocess as sp
import re
import numpy as np
import pandas as pd

work_dir = "./popgen/04_rfmix/" + \
    "including_mais_samples//seven_way/"
job_dir = work_dir + "jobs/"
log_dir = work_dir + "logs/"

id_file1 = work_dir + "output_files/examples.n16.rgn-ids.txt"
id_file2 = work_dir + "output_files/examples.amr20.rgn-ids.txt"

def submit_collapse_job(samp, shmem):
    job_name = samp + "_collapse"
    script = '''#!/bin/bash
#$ -cwd
#$ -N j7_%s
#$ -q short.qc
#$ -o %s.out
#$ -e %s.err
#$ -pe shmem %s

echo "------------------------------------------------"
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at: "`date`
echo "------------------------------------------------"

module load Python/3.7.4-GCCcore-8.3.0
source python/projectA-ivybridge/bin/activate
python %s %s

    ''' % (job_name, log_dir + job_name, log_dir + job_name, str(shmem), 
    work_dir + "04.0_collapse-individual-rfmix-info.py", samp)
    fout = open(job_dir + "j_" + job_name  +  ".sh", 'w')
    fout.write(script)
    fout.close()
    command = ["qsub", job_dir + "j_" + job_name + ".sh"]
    sp.check_call(command)

def main():
    fin1 = open(id_file1, 'r')
    fin2 = open(id_file2, 'r')
    samp_list = []
    for line in fin1:
        samp = line.strip()
        samp_list.append(samp)
    for line in fin2:
        samp = line.strip()
        samp_list.append(samp)
    fin1.close()
    fin2.close()
    for samp in samp_list:
        print(samp)
        submit_collapse_job(samp, 2)


if (__name__=="__main__"):
     main()
