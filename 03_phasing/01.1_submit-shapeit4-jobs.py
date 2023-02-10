#!/usr/bin/python -O
# Jason Matthew Torres
'''
module load Python/3.7.4-GCCcore-8.3.0
python 01.1_submit-shapeit4-jobs.py
'''
# libraries
import sys,os
import subprocess as sp

work_dir = "popgen/03_phasing/"
job_dir = work_dir + "jobs/"
log_dir = work_dir +"logs/"
in_dir = work_dir + "input_files/"
out_dir = work_dir + "output_files/"
plink2="/apps/well/plink/2.00a-20170724/plink2"
geno_dir = "popgen/01_pca/public_mais/merged_mais-hgdp-1kg/"
geno_prefix = "merged_reference_rsq90" 
gmap_dir = work_dir  +  "gmap_files/"


def submit_shapeit4_job(chromo,shmem):
    job_name = "chr" + str(chromo)  +  "_shapeit4"
    script = '''#!/bin/bash
#$ -cwd
#$ -P emberson.prjc
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
module load SHAPEIT4/4.1.3-foss-2019b

%s --bfile %s --chr %s \
 --export vcf bgz id-delim="-" \
 --out %s

bcftools index %s

shapeit4 --input %s \
 --map %s \
 --region %s \
 -T 16 \
 --output %s \
 --log %s

bgzip -c %s > %s
bcftools index %s

    ''' % (job_name,log_dir + job_name,log_dir + job_name,str(shmem),
    plink2,geno_dir + geno_prefix,str(chromo),in_dir + geno_prefix + "_chr" + str(chromo),
    in_dir + geno_prefix + "_chr" + str(chromo) + ".vcf.gz",
    in_dir + geno_prefix + "_chr" + str(chromo) + ".vcf.gz",
    gmap_dir + "chr" + str(chromo) + ".b38.gmap.gz",str(chromo),
    out_dir + geno_prefix + "_chr" + str(chromo) + "_phased.vcf",
    log_dir + "shapeit4_chr" + str(chromo) + ".log",
    out_dir + geno_prefix + "_chr" + str(chromo) + "_phased.vcf",
    out_dir + geno_prefix + "_chr" + str(chromo) + "_phased.vcf.gz",
    out_dir + geno_prefix + "_chr" + str(chromo) + "_phased.vcf.gz")

    fout = open(job_dir + job_name + ".sh",'w')
    fout.write(script)
    fout.close()
    command = ["qsub",job_dir + job_name + ".sh"]
    sp.check_call(command)

def main():
    # Note: adjusted shmem value according to chromosome file size
    for c in range(6,23):
        submit_shapeit4_job(c,2) 
    for c in range(9,15):
        submit_shapeit4_job(c,3) 
    for c in range(1,9):
        submit_shapeit4_job(c,4) 




if (__name__=="__main__"):
     main()
