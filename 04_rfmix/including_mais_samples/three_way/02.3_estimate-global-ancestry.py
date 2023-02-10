#!/usr/bin/python -O
# Jason Matthew Torres
'''
module load Python/3.7.4-GCCcore-8.3.0
source python/projectA-ivybridge/bin/activate
python 02.3_estimate-global-ancestry.py
'''
# libraries
import sys, os
import subprocess as sp
import numpy as np


work_dir = "popgen/04_rfmix/including_mais_samples/three_way/"
job_dir = work_dir + "jobs/"
log_dir = work_dir + "logs/"
in_dir = work_dir + "input_files/"
out_dir = work_dir + "output_files/"
chromsize_file = in_dir + "hg38.chrom.sizes"
anc_list = ["AFRICA", "AMERICA", "EUROPE"]

def build_chromsize_dic():
    dic = {}
    chrom_list = ["chr" + str(i) for i in range(1, 23)]
    chrom_list= chrom_list + ["chrX", "chrY"]
    fin = open(chromsize_file, 'r')
    for line in fin:
        l = line.strip().split()
        chrom, length = l[0], l[1]
        if chrom in chrom_list:
            dic[chrom]=length
    fin.close()
    return(dic)

def get_id_list():
    chrom_file = out_dir + "mcps.rfmix.chr22.rfmix.Q"
    ind_list = []
    fin = open(chrom_file, 'r')
    fin.readline() # comment line
    fin.readline() # header line
    for line in fin:
        l = line.strip().split()
        ind = l[0]
        ind_list.append(ind)
    fin.close()
    return(ind_list)

def global_ancestry_estimate():
    chrom_list = ["chr" + str(i) for i in range(1, 23)]
    chrom_dic = build_chromsize_dic()
    ind_list = get_id_list()
    # Build dictionary of sums of ancestry proportions * chromosome lengths
    ancestry_dic = {}
    for chrom in chrom_list:
        chrom_file = out_dir + "mcps.rfmix." + chrom + ".rfmix.Q"
        if os.path.isfile(chrom_file):
            print("Weighting ancestry proportions for %s" % chrom)
            chrom_len = float(chrom_dic[chrom])
            fin = open(chrom_file, 'r')
            fin.readline() # comment line
            fin.readline() # header line
            for line in fin:
                l = line.strip().split()
                ind = l.pop(0)
                arr = np.array([float(e) for e in l])
                wsum = chrom_len * arr
                try:
                    ancestry_dic[ind] = ancestry_dic[ind] + wsum
                except:
                    ancestry_dic[ind] = wsum
            fin.close()
        else:
            print("There is no rfmix.Q file for %s" % chrom)
    # Determine proportions and write output
    print("Calculating global ancestry proportion estimates")
    fout = open(out_dir + "global-ancestry-estimates.txt", 'w')
    header_list = ["IID"] + anc_list
    fout.write("\t".join(header_list)+"\n")
    for ind in ind_list:
        wsums = ancestry_dic[ind]
        props = wsums / sum(wsums)
        write_list = [round(i, 4) for i in props]
        write_list = [ind] + [str(e) for e in write_list]
        fout.write("\t".join(write_list)+"\n")
    fout.close()

def main():
    global_ancestry_estimate()


if (__name__=="__main__"):
     main()
