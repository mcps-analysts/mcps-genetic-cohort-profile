#!/usr/bin/python -O
# Jason Matthew Torres
'''
module load Python/3.7.4-GCCcore-8.3.0
python 03.1_terastructure-select-k.py
'''
# libraries
import sys,os
import subprocess as sp

work_dir = "popgen/02.1_terastructure/mais_amr_afr_eur_eas/"
job_dir = work_dir + "jobs/"
log_dir = work_dir + "logs/"
out_dir = work_dir + "output_files/"
terastructure="shared/software/terastructure/terastructure/package_bin/bin/terastructure"
geno_dir = work_dir + "input_files/"
geno_prefix = "subset-samples"
nsnps = 226827
ninds = 3274

# SNP Percentages
# 5%: 11341
# 10%: 22683
# 15%: 34024
# 20%: 45365

rfreq= 45365
k_list = [str(i) for i in range(3,6)]

def submit_tera_job(index,rfreq,iter):
    k = k_list[index]
    job_name = "k_" + str(k) + "_rep" + str(iter)
    script = '''#!/bin/bash
#$ -wd %s
#$ -N %s
#$ -q long.qc
#$ -o %s.out
#$ -e %s.err
#$ -pe shmem 2

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
-k %s \
-nthreads 16 \
-rfreq %s \
-label %s \
-force
    ''' % (out_dir,job_name,log_dir + job_name,log_dir + job_name,
    terastructure,geno_dir,geno_prefix,str(ninds),str(nsnps),str(k),
    str(rfreq),"select_k_" + str(k) + "_rep" + str(iter))
    fout = open(job_dir + job_name + ".sh",'w')
    fout.write(script)
    fout.close()
    command = ["qsub",job_dir + job_name + ".sh"]
    sp.check_call(command)

def main():
    for i in range(0,4):
        for iter in range(1,4):
            submit_tera_job(i,rfreq,iter) # rfreq = 34774; 20% value

if (__name__=="__main__"):
     main()
