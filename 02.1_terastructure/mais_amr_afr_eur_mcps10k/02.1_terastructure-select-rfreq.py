#!/usr/bin/python -O
# Jason Matthew Torres
'''
module load Python/3.7.4-GCCcore-8.3.0
python 02.1_terastructure-select-rfreq.py
'''
# libraries
import sys,os
import subprocess as sp

work_dir = "popgen/02.1_terastructure/mais_amr_afr_eur_mcps10k/"
job_dir = work_dir+"jobs/"
log_dir = work_dir+"logs/"
out_dir = work_dir+"output_files/"
terastructure="shared/software/terastructure/terastructure/package_bin/bin/terastructure"
geno_dir = work_dir + "input_files/"
geno_prefix = "subset-samples"
nsnps = 199247 
ninds = 11989

# SNP Percentages
# 5%: 9962
# 10%: 19925
# 15%: 29887
# 20%: 39849

name_list = ['05','10','15','20']
rfreq_list = [9962,19925,29887,39849]

def submit_tera_job(index):
    name = name_list[index]
    rfreq = rfreq_list[index]
    job_name = "rfreq_" + str(name)

    script = '''#!/bin/bash
#$ -wd %s
#$ -N %s
#$ -q long.qc
#$ -o %s.out
#$ -e %s.err
#$ -pe shmem 4

echo "------------------------------------------------"
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at: "`date`
echo "------------------------------------------------"

module load GSL/2.4-GCCcore-6.4.0

%s -file %s%s.bed \
-n %s \
-l %s \
-k 3 \
-seed 1 \
-nthreads 16 \
-rfreq %s \
-label %s \
-force
    ''' % (out_dir,job_name,log_dir+job_name,log_dir+job_name,
    terastructure,geno_dir,geno_prefix,str(ninds),str(nsnps),
    str(rfreq),"select_rfreq_"+name)
    fout = open(job_dir + job_name + ".sh",'w')
    fout.write(script)
    fout.close()
    command = ["qsub",job_dir + job_name + ".sh"]
    sp.check_call(command)

def main():
    for i in range(0,4):
        submit_tera_job(i)

if (__name__=="__main__"):
     main()
