#!/usr/bin/python -O
# Jason Matthew Torres
'''
Usage:
source python/projectA-ivybridge/bin/activate
module load Python/3.7.4-GCCcore-8.3.0
python 01.1.1_subset-hgdp-snps.py
'''
# libraries
import sys,os,gzip
from time import sleep
import subprocess as sp
import pandas as pd

ref_dir =  "./shared/reference_datasets/hgdp_sanger/"
metadata_file = ref_dir + "hgdp_wgs.20190516.metadata.txt"
pvcf_dir = "data/GSAv2_CHIP/pVCF/"
bim_file = pvcf_dir + "MCPS_Freeze_100.GT_hg38.pVCF.bim"
work_dir = "./popgen/04_rfmix/public_references_only/00_chromosomeX/"
job_dir = work_dir + "hgdp/jobs/"
log_dir = work_dir + "hgdp/logs/"
out_dir = work_dir + "hgdp/geno_files/"
bcftools = "./shared/software/bcftools/bcftools/bcftools"
plink2 = "./shared/software/plink2/plink2"

def create_sample_keep_file():
    df = pd.read_csv(metadata_file,sep="\t",header=0)
    df['sample'].to_csv(out_dir + "hgdp_samples.txt",sep="\t",\
    header=False,index=False)

def create_snp_keep_file():
    df = pd.read_csv(bim_file,sep="\t",header=None)
    print(df.shape)
    df[0] = 'chr' + df[0].astype(str)
    df.to_csv(out_dir+"gsav2_snps.txt",sep="\t",header=False,index=False,\
    columns=[0,3])

def submit_vcf_subset_job(chromo):
    arg_list_1 = [bcftools,"view","--samples-file",\
    out_dir + "hgdp_samples.txt","--force-samples",ref_dir + "hgdp_wgs.20190516.full." + chromo + ".vcf.gz", \
    "-Oz", "-o",out_dir + "hgdp." + chromo + ".vcf.gz"]

    # Index vcf.gz file
    arg_list_2 = [bcftools,"index",out_dir + "hgdp." + chromo + ".vcf.gz"]
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

    ''' % (chromo,log_dir + chromo,log_dir + chromo,arg_string_1,arg_string_2)
    fout = open(job_dir + chromo + "_job.sh",'w')
    fout.write(script)
    fout.close()
    command = ["qsub",job_dir + chromo + "_job.sh"]
    sp.check_call(command)

def submit_vcf_subset_jobs():
    chrom_list = ["chrX","chrY"]
    for chrom in chrom_list:
        submit_vcf_subset_job(chrom)

def gsav2_subset_vcf_files():
    print("Chromsome: Y")
    # Subset SNPs in GSAv2 array
    sys.stdout.write("Extracting GSAv2 SNPs...." + "\n")
    bcftools_arg_list1 = [bcftools,"filter","--regions-file",\
    out_dir + "gsav2_snps.txt",out_dir + "hgdp.chrY.vcf.gz", \
    "-Oz", "-o",out_dir + "hgdp.chrY.gsav2.vcf.gz"]
    sp.check_call(bcftools_arg_list1)
    sys.stdout.write("Indexing concatanated VCF file...." + "\n")
    bcftools_arg_list1b = [bcftools,"index",out_dir + "hgdp.chrY.gsav2.vcf.gz"]
    sp.check_call(bcftools_arg_list1b)

    print("Chromsome: X")
    # Subset SNPs in GSAv2 array
    sys.stdout.write("Extracting GSAv2 SNPs...." + "\n")
    bcftools_arg_list2 = [bcftools,"filter","--regions-file",\
    out_dir + "gsav2_snps.txt",out_dir + "hgdp.chrX.vcf.gz", \
    "-Oz", "-o",out_dir + "hgdp.chrX.gsav2.vcf.gz"]
    sp.check_call(bcftools_arg_list2)
    sys.stdout.write("Indexing concatanated VCF file...." + "\n")
    bcftools_arg_list2b = [bcftools,"index",out_dir + "hgdp.chrX.gsav2.vcf.gz"]
    sp.check_call(bcftools_arg_list2b)

def make_plink_files():
    plink_arg_list_y = [plink2, "--vcf",out_dir + "hgdp.chrY.gsav2.vcf.gz","--max-alleles","2",\
    "--make-bed","--out",out_dir + "hgdp.chrY.gsav2"]
    sp.check_call(plink_arg_list_y)

    plink_arg_list_x = [plink2, "--vcf",out_dir + "hgdp.chrX.gsav2.vcf.gz","--max-alleles","2",\
    "--make-bed","--out",out_dir + "hgdp.chrX.gsav2"]
    sp.check_call(plink_arg_list_x)

def main():
    create_sample_keep_file()
    create_snp_keep_file()
    submit_vcf_subset_jobs()
    gsav2_subset_vcf_files()
    make_plink_files()


if (__name__=="__main__"):
     main()
