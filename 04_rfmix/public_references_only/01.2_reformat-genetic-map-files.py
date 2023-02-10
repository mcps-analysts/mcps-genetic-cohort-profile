#!/usr/bin/python -O
# Jason Matthew Torres
'''
Usage:
module load Python/3.7.4-GCCcore-8.3.0
python 02.1_reformat-genetic-map-files.py
'''
# libraries
import sys,os,gzip
import subprocess as sp

work_dir = "popgen/04_rfmix/"
phase_dir = "popgen/03_phasing/"
gmap_dir = phase_dir + "gmap_files/"
out_dir = work_dir + "gmap_files/"

def reformat_gmap_file(chromo):
    fin = gzip.open(gmap_dir + "chr" + str(chromo) + ".b38.gmap.gz",'rb')
    fout = open(out_dir + "chr" + str(chromo) + ".b38.reformat.gmap",'w')
    fin.readline() # header line 
    for line in fin:
        l = line.strip().split()
        pos,chrom,cm=l[0].decode("utf-8"),l[1].decode("utf-8"),l[2].decode("utf-8")
        write_list = [chrom,pos,cm]
        fout.write("\t".join(write_list) + "\n")
    fin.close()

def main():
    for c in range(1,23):
        print("Reformatting gmap file for chromosome: %d" % c)
        reformat_gmap_file(c)

if (__name__=="__main__"):
     main()
