#!/usr/bin/python -O
# Jason Matthew Torres
'''
module load Python/3.7.4-GCCcore-8.3.0
python 02.1_prepare-ref-vcfs-jobs.py
'''
# libraries
import sys,os
import subprocess as sp

vcftools="/apps/well/vcftools/0.1.14-gcc4.7.2/bin/vcftools"
rfmix= "shared/software/rfmix/rfmix"
work_dir = "popgen/04_rfmix/"
work_dir = work_dir + "including_mais_samples/three_way/"
job_dir = work_dir + "jobs/"
log_dir = work_dir + "logs/"
in_dir = work_dir + "input_files/"
out_dir = work_dir + "output_files/"
gmap_dir = work_dir + "gmap_files/"
phase_dir = "popgen/03_phasing/"
vcf_dir = phase_dir + "output_files/"
vcf_pre ="merged_reference_rsq90_chr"
vcf_post = "_phased.vcf"
samp_file = in_dir + "mcps-samples.txt"
ref_file = in_dir + "ref-samples.txt"


def submit_vcf_job(chromo,shmem):
    job_name = "chr" + str(chromo) + "_vcf"
    script = '''#!/bin/bash
#$ -cwd
#$ -N %s
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

module load BCFtools/1.10.2-GCC-8.3.0

##make a vcf file of just the reference individuals
%s --vcf %s \
  --keep %s \
  --recode --out %s

bgzip %s

    ''' % (job_name,log_dir + job_name,log_dir + job_name,str(shmem),
    vcftools,vcf_dir + vcf_pre + str(chromo) + vcf_post,ref_file,in_dir + "ref.cohort.chr" + str(chromo),
    in_dir + "ref.cohort.chr" + str(chromo) + ".recode.vcf")

    fout = open(job_dir + job_name + ".sh",'w')
    fout.write(script)
    fout.close()
    command = ["qsub",job_dir + job_name + ".sh"]
    sp.check_call(command)

def main():
    for c in range(1,23):
        submit_vcf_job(c,1)

if (__name__=="__main__"):
     main()
