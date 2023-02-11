#!/usr/bin/python -O
# Jason Matthew Torres
'''

module load Python/3.7.4-GCCcore-8.3.0
python 01.2_sync-snpids.py

'''
# libraries
import sys,os
from shutil import copyfile
import subprocess as sp

work_dir = "popgen/04_rfmix/public_references_only/00_chromosomeX/"
plink2 = "shared/software/plink2/plink2"

def sync_snps(study_dir,chrom,study_name):
    sys.stdout.write("\nRunning dataset: %s\n" % study_name)
    sys.stdout.write("\nRunning chromosome: %s\n" % chrom)
    bim_file = study_dir + study_name + "." + chrom + ".gsav2.bim"
    copyfile(bim_file,bim_file + "_copy")
    fin = open(bim_file + "_copy",'r')
    fout = open(bim_file + "_temp",'w')
    fout2 = open(study_dir + study_name + ".indels.txt",'w')
    count = 0
    for line in fin:
        count += 1
        sys.stdout.write("\r")
        sys.stdout.write("Count: %d" % count)
        sys.stdout.flush()
        l = line.strip().split()
        chrom,pos = l[0],l[3]
        a1,a2 = l[4],l[5]
        a_list = [len(a1),len(a2)]
        a_list.sort(reverse=True)
        max_a_num = a_list[0]
        snpid = chrom + ":" + pos
        if max_a_num > 1:
            snpid = snpid  +  ":" + str(max_a_num)
            fout2.write(snpid + "\n")
        l[1] = snpid
        fout.write("\t".join(l) + "\n")
    fin.close()
    fout.close()
    fout2.close()
    os.rename(bim_file + "_temp",bim_file)

def plink_subset(study_dir,chrom,study_name):
    prefix = study_dir + study_name +  "." + chrom + ".gsav2"
    indel_file = study_dir + study_name + ".indels.txt"
    command = [plink2, "--bfile", prefix, "--exclude", indel_file,\
    "--make-bed","--out",prefix + ".biallelic"]
    sp.check_call(command)


def main():
    study_dir1 = work_dir + "hgdp/geno_files/"
    study_dir2 = work_dir + "1kgenomes/geno_files/"
    study_name1 = "hgdp"
    study_name2 = "1kg"

    sync_snps(study_dir1,"chrY",study_name1)
    sync_snps(study_dir2,"chrY",study_name2)
    sync_snps(study_dir1,"chrX",study_name1)
    sync_snps(study_dir2,"chrX",study_name2)
    plink_subset(study_dir1,"chrY",study_name1)
    plink_subset(study_dir2,"chrY",study_name2)
    plink_subset(study_dir1,"chrX",study_name1)
    plink_subset(study_dir2,"chrX",study_name2)


if (__name__=="__main__"):
     main()
