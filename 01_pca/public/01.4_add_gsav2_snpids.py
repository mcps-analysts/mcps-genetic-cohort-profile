#!/usr/bin/python -O
# Jason Matthew Torres
'''
Usage:
module load Python/3.7.4-GCCcore-8.3.0
python 01.4_script.py
'''
# libraries
import sys, os

work_dir = "./popgen/01_pca/public/"
study_dir =  "./projects/mcps/data/genetics_regeneron/freeze_150k/data/GSAv2_CHIP/pVCF/qcd2/"
study_name = "MCPS_Freeze_150.GT_hg38.pVCF.qcd2"
ref_dir = work_dir + "merged/"
ref_name = "merged_hgdp-1kg"

def create_snpdic_from_bim(study_dir, study_name):
    fin = open(study_dir + study_name + ".bim", 'r')
    dic = {}
    count = 0
    for line in fin:
        count+=1
        sys.stdout.write("\r")
        sys.stdout.write("Count: %d" % count)
        sys.stdout.flush()
        l = line.strip().split()
        chrom, snpid, pos = l[0], l[1], l[3]
        k = chrom + ":" + pos
        dic[k] = snpid
    fin.close()
    return dic

def add_snpids(snpdic, ref_dir, ref_name):
    fin = open(ref_dir + ref_name + ".bim", 'r')
    fout = open(ref_dir + "temp.bim", 'w')
    count=0
    noid_count=0
    sys.stdout.write("\n")
    for line in fin:
        count+=1
        sys.stdout.write("\r")
        sys.stdout.write("Count: %d" % count)
        sys.stdout.flush()
        l = line.strip().split()
        chrom, snpid, pos = l[0], l[1], l[3]
        k = chrom + ":" + pos
        try:
            snpid = snpdic[k]
        except:
            snpid = k
            noid_count+=1
        write_list = [l[0], snpid, l[2], l[3], l[4], l[5]]
        fout.write("\t".join(write_list) + "\n")
    sys.stdout.write("\n")
    sys.stdout.write("Number of reference SNPs that couldn't yield id mapping: %d\n" % noid_count)
    fin.close()
    fout.close()
    os.rename(ref_dir + ref_name + ".bim", ref_dir + ref_name + "_original.bim")
    os.rename(ref_dir + "temp.bim", ref_dir + ref_name + ".bim")


def main():
    snpdic = create_snpdic_from_bim(study_dir, study_name)
    add_snpids(snpdic, ref_dir, ref_name)

if (__name__=="__main__"):
     main()
