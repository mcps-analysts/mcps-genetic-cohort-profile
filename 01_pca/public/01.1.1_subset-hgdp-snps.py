#!/usr/bin/python -O
# Jason Matthew Torres
'''

module load Python/3.7.4-GCCcore-8.3.0
python 01.1.1_subset-hgdp-snps.py

'''
# libraries
import sys, os, gzip
from time import sleep
import subprocess as sp
import pandas as pd

ref_dir =  "./reference_datasets/hgdp_sanger/"
metadata_file = ref_dir + "hgdp_wgs.20190516.metadata.txt"
pvcf_dir = "./projects/mcps/data/genotyping/freeze_100k/data/GSAv2_CHIP/pVCF/"
bim_file = pvcf_dir + "MCPS_Freeze_100.GT_hg38.pVCF.bim"
work_dir = "./popgen/01_pca/public/"
job_dir = work_dir + "hgdp/jobs/"
log_dir = work_dir + "hgdp/logs/"
out_dir = work_dir + "hgdp/geno_files/"
bcftools = "/apps/well/bcftools/1.4.1/bin/bcftools"
plink2 = "/apps/well/plink/2.00a-20170724/plink2"

def create_sample_keep_file():
    df = pd.read_csv(metadata_file, sep="\t", header=0)
    df['sample'].to_csv(out_dir + "hgdp_samples.txt", sep="\t", \
    header=False, index=False)

def create_snp_keep_file():
    df = pd.read_csv(bim_file, sep="\t", header=None)
    print(df.shape)
    df[0] = 'chr' + df[0].astype(str)
    df.to_csv(out_dir + "gsav2_snps.txt", sep="\t", header=False, index=False, \
    columns=[0, 3])

def submit_vcf_subset_job(chromo):
    ### Subset samples in vcf.gz file
    arg_list_1 = [bcftools, "view", "--samples-file", \
    out_dir + "hgdp_samples.txt", ref_dir + "hgdp_wgs.20190516.full." + chromo + ".vcf.gz",  \
    "-Oz",  "-o", out_dir + "hgdp." + chromo + ".vcf.gz"]

    # Index vcf.gz file
    arg_list_2 = [bcftools, "index", out_dir + "hgdp." + chromo + ".vcf.gz"]
    arg_string_1 = " ".join(arg_list_1)
    arg_string_2 = " ".join(arg_list_2)
    script = '''
#!/bin/bash
#$ -cwd
#$ -N pyjob-%s-hgdp
#$ -q short.qc
#$ -o %s.out
#$ -e %s.err

echo "------------------------------------------------"
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at: "`date`
echo "------------------------------------------------"

%s
%s

    ''' % (chromo, log_dir + chromo, log_dir + chromo, arg_string_1, arg_string_2)
    fout = open(job_dir + chromo + "_job.sh", 'w')
    fout.write(script)
    fout.close()
    command = ["qsub", job_dir + chromo + "_job.sh"]
    sp.check_call(command)

def submit_vcf_subset_jobs():
    chrom_list = ["chr" + str(i) for i in range(1, 23)]
    for chrom in chrom_list:
        submit_vcf_subset_job(chrom)

def concat_vcf_files():
    vcf_list = [out_dir + "hgdp.chr" + str(i) + ".vcf.gz" for i in range(1, 23)]
    ref_file = out_dir + "vcf_file_list.txt"
    fout = open(ref_file, 'w')
    for f in vcf_list:
        fout.write(f + "\n")
    fout.close()
    sys.stdout.write("Concatanating VCF files...." + "\n")
    bcftools_arg_list = [bcftools, "concat", "--file-list", ref_file, \
    "--threads", "16", "--output-type",  "z", "--output", \
    out_dir+"hgdp.all.vcf.gz"]
    sp.check_call(bcftools_arg_list)

    # Index the concatenated file
    sys.stdout.write("Indexing concatanated VCF file...." + "\n")
    bcftools_arg_list1b = [bcftools, "index", out_dir + "hgdp.all.vcf.gz"]
    sp.check_call(bcftools_arg_list1b)

    # Subset SNPs in GSAv2 array
    sys.stdout.write("Extracting GSAv2 SNPs...." + "\n")
    bcftools_arg_list2 = [bcftools, "filter", "--regions-file", \
    out_dir + "gsav2_snps.txt", out_dir + "hgdp.all.vcf.gz",  \
    "-Oz",  "-o", out_dir + "hgdp.gsav2.vcf.gz"]
    sp.check_call(bcftools_arg_list2)

def make_plink_files():
    plink_arg_list = [plink2,  "--vcf", out_dir + "hgdp.gsav2.vcf.gz", \
    "--make-bed", "--out", out_dir + "hgdp.gsav2"]
    sp.check_call(plink_arg_list)

def main():
    create_sample_keep_file()
    create_snp_keep_file()
    submit_vcf_subset_jobs()
    concat_vcf_files()
    make_plink_files()


if (__name__=="__main__"):
     main()
