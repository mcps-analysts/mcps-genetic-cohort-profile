#!/usr/bin/python -O
# Jason Matthew Torres
'''
module load Python/3.7.4-GCCcore-8.3.0
python 02.2_submit-rfmix-jobs.py
'''
# libraries
import sys, os
import subprocess as sp

vcftools="/apps/well/vcftools/0.1.14-gcc4.7.2/bin/vcftools"
rfmix="shared/software/rfmix/rfmix"
work_dir = "popgen/04_rfmix/"
work_dir = work_dir + "including_mais_samples/seven_way/"
job_dir = work_dir + "jobs/"
log_dir = work_dir + "logs/"
in_dir = work_dir + "input_files/"
out_dir = work_dir + "output_files/"
gmap_dir = work_dir + "gmap_files/"
phase_dir = "popgen/03_phasing/"
vcf_dir = phase_dir + "output_files/"
vcf_pre = "merged_reference_rsq90_chr"
vcf_post = "_phased.vcf"
samp_file = in_dir + "mcps-samples.txt"
ref_file = in_dir + "ref-samples.txt"


def submit_rfmix_job(chromo, q_name, shmem):
    job_name = "chr" + str(chromo) + "_rf7_em10"
    script = '''#!/bin/bash
#$ -cwd
#$ -N %s
#$ -q %s
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

%s -f %s \
  -r %s \
  --chromosome=%s \
  -m %s \
  -g %s \
  -n 5 -e 10 \
  --debug=1 -G 15 \
  -num-threads 16 \
  -o %s

    ''' % (job_name, q_name, log_dir + job_name, log_dir + job_name, str(shmem), 
    rfmix, in_dir + str(chromo) + ".phased.vcf.gz", 
    in_dir + "ref.cohort.chr" + str(chromo) + ".recode.vcf.gz", str(chromo), 
    in_dir + "ref-map.txt", 
    gmap_dir + "chr" + str(chromo) + ".b38.reformat.gmap", 
    out_dir + "mcps.rfmix.chr" + str(chromo))

    fout = open(job_dir + job_name + ".sh", 'w')
    fout.write(script)
    fout.close()
    command = ["qsub", job_dir + job_name + ".sh"]
    sp.check_call(command)

def main():
    # Note: adjusted shmem value according to chromosome
    for c in range(1, 6):
        submit_rfmix_job(c, "himem.qh", 10)
    for c in range(6, 8):
        submit_rfmix_job(c, "long.qc", 24)
    for c in range(8, 10):
        submit_rfmix_job(c, "long.qc", 23)
    for c in range(10, 16):
        submit_rfmix_job(c, "long.qc", 22)
    for c in range(16, 23):
        submit_rfmix_job(c, "long.qc", 20)


if (__name__=="__main__"):
     main()
