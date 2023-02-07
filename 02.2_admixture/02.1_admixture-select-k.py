#!/usr/bin/python -O
# Jason Matthew Torres
'''
module load Python/3.7.4-GCCcore-8.3.0
python 02.1_admixture-select-k.py
'''
# libraries
import sys,os
import subprocess as sp

serv_dir = ""
work_dir = serv_dir + "popgen/02.2_admixture/"
work_dir = work_dir + "afr_eas_eur_mais_amr-select-mcps1k/"
job_dir = work_dir+"jobs/"
log_dir = work_dir+"logs/"
out_dir = work_dir+"output_files/"
admixture=serv_dir+"shared/software/admixture_1.3.0/dist/admixture_linux-1.3.0/admixture"
geno_dir = work_dir + "input_files/"
ref_pre = "ref"
study_pre = "mcps150k"

k_list = [str(i) for i in range(4,26)]

def submit_admix_job(k):
    job_name = "k_" + str(k) +"_admix"
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

%s --cv %s %s -j24
    ''' % (out_dir,job_name,log_dir+job_name,log_dir+job_name,
    admixture,geno_dir+ref_pre+".bed",k)
    fout = open(job_dir + job_name + ".sh",'w')
    fout.write(script)
    fout.close()
    command = ["qsub",job_dir + job_name + ".sh"]
    sp.check_call(command)

def main():
    for k in k_list:
        print(k)
        submit_admix_job(k)

if (__name__=="__main__"):
     main()
