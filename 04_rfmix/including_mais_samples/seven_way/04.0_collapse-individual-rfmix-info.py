#!/usr/bin/python -O
# Jason Matthew Torres
'''
module load Python/3.7.4-GCCcore-8.3.0
source python/projectA-ivybridge/bin/activate
python 04.1_collapse-individual-rfmix-info.py
'''
# libraries
import sys, os
import subprocess as sp
import re
import numpy as np
import pandas as pd

work_dir = "popgen/04_rfmix/including_mais_samples/seven_way/"
out_dir = work_dir + "output_files/collapsed_info/"
pop_list = ["AFRICA", "EUROPE", "MEXICO_C", "MEXICO_N", "MEXICO_NW", \
    "MEXICO_S", "MEXICO_SE"]
prob_thresh = 0.9
chrom_file = work_dir + "output_files/chromosome-gmap-coords.txt"

input_sample = sys.argv[1]

def get_chrom_dic():
    dic = {}
    fin = open(chrom_file, 'r')
    fin.readline()
    for line in fin:
        l = line.strip().split()
        chrom, spos, epos, sgpos, egpos = l[0], l[1], l[2], l[3], l[4]
        dic[chrom] = [spos, epos, sgpos, egpos]
    fin.close()
    return dic


def collapse(sample):
    chrom_dic = get_chrom_dic()
    foutA = open(out_dir + sample + "_A.bed", 'w')
    foutB = open(out_dir + sample + "_B.bed", 'w')
    chrom_vec = ["chr" + str(i) for i in range(1, 23)]
    sample_indices = []
    for chrom in chrom_vec:
        print("Chromosome: %s" % chrom )
        input_file = work_dir + "output_files/mcps.rfmix." + chrom + ".fb.tsv"
        fin = open(input_file, 'r')
        fin.readline() # header line 1
        header_list = fin.readline().strip().split() # header line 2
        if len(sample_indices)==0:
            search_list = [re.search(sample, x)!=None for x in header_list]
            sample_indices = [x for x in range(0, len(search_list)) if search_list[x]==True]
            n_pops = int(len(sample_indices)/2)
            hap_a_indices = sample_indices[:n_pops]
            hap_b_indices = sample_indices[n_pops:]
        # First segment
        l = fin.readline().strip().split()
        chrom, phys_pos, gen_pos = l[0], l[1], l[2]
        hap_a_list = [l[x] for x in hap_a_indices]
        hap_b_list = [l[x] for x in hap_b_indices]
        hap_a_max_index = [i for i in range(0, len(hap_a_list)) if float(hap_a_list[i]) > prob_thresh]
        hap_b_max_index = [i for i in range(0, len(hap_b_list)) if float(hap_b_list[i]) > prob_thresh]
        try:
            hap_a_max_ancestry = [pop_list[i] for i in hap_a_max_index][0]
        except:
            hap_a_max_ancestry = "Unknown"
        try:
            hap_b_max_ancestry = [pop_list[i] for i in hap_b_max_index][0]
        except:
            hap_b_max_ancestry = "Unknown"
        hap_a_start_phys,  hap_a_start_gen = phys_pos, gen_pos
        hap_a_prev_anc = hap_a_max_ancestry
        hap_b_start_phys,  hap_b_start_gen = phys_pos, gen_pos
        hap_b_prev_anc = hap_b_max_ancestry
        for line in fin:
            l = line.strip().split()
            chrom, phys_pos, gen_pos = l[0], l[1], l[2]
            ## Haplotype A
            hap_a_list = [l[x] for x in hap_a_indices]
            hap_a_max_index = [i for i in range(0, len(hap_a_list)) if float(hap_a_list[i]) > prob_thresh]
            try:
                hap_a_max_ancestry = [pop_list[i] for i in hap_a_max_index][0]
            except:
                hap_a_max_ancestry = "Unknown"
            if hap_a_max_ancestry == hap_a_prev_anc:
                continue
            elif hap_a_max_ancestry != hap_a_prev_anc:
                hap_a_end_phys,  hap_a_end_gen = phys_pos, gen_pos
                write_list = [chrom, hap_a_start_gen, hap_a_end_gen, hap_a_prev_anc, 
                hap_a_start_phys, hap_a_end_phys]
                foutA.write("\t".join(write_list) + "\n")
                hap_a_start_phys,  hap_a_start_gen = phys_pos, gen_pos
                hap_a_prev_anc = hap_a_max_ancestry
            else:
                raise ValueError("haplotype A ancestry is not valid")
            ## Haplotype B
            hap_b_list = [l[x] for x in hap_b_indices]
            hap_b_max_index = [i for i in range(0, len(hap_b_list)) if float(hap_b_list[i]) > prob_thresh]
            try:
                hap_b_max_ancestry = [pop_list[i] for i in hap_b_max_index][0]
            except:
                hap_b_max_ancestry = "Unknown"
            if hap_b_max_ancestry == hap_b_prev_anc:
                continue
            elif hap_b_max_ancestry != hap_b_prev_anc:
                hap_b_end_phys,  hap_b_end_gen = phys_pos, gen_pos
                write_list = [chrom, hap_b_start_gen, hap_b_end_gen, hap_b_prev_anc, 
                hap_b_start_phys, hap_b_end_phys]
                foutB.write("\t".join(write_list) + "\n")
                hap_b_start_phys,  hap_b_start_gen = phys_pos, gen_pos
                hap_b_prev_anc = hap_b_max_ancestry
            else:
                raise ValueError("haplotype B ancestry is not valid")
        # Final segment
        hap_a_end_gen, hap_a_end_phys = chrom_dic[chrom][3],  chrom_dic[chrom][1]
        write_list = [chrom, hap_a_start_gen, hap_a_end_gen, hap_a_prev_anc, 
        hap_a_start_phys, hap_a_end_phys]
        foutA.write("\t".join(write_list) + "\n")
        hap_b_end_gen, hap_b_end_phys = chrom_dic[chrom][3],  chrom_dic[chrom][1]
        write_list = [chrom, hap_b_start_gen, hap_b_end_gen, hap_b_prev_anc, 
        hap_b_start_phys, hap_b_end_phys]
        foutB.write("\t".join(write_list) + "\n")
        fin.close()
    foutA.close()
    foutB.close()

def main():
    collapse(input_sample)


if (__name__=="__main__"):
     main()
