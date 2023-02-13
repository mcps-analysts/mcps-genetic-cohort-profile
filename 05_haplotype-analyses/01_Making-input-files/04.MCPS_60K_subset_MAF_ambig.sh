#!/bin/bash
#$ -cwd
#$ -N MT_MCPS_removing_relateds_MAF_ambig
#$ -q short.qc
#$ -pe shmem 2
#$ -t 1-22:1
#$ -o ./data/QC_datasets/60K_files/logs/MT_MCPS_60K_vcf_processing/
#$ -e ./data/QC_datasets/60K_files/logs/MT_MCPS_60K_vcf_processing/

echo "-----------------------------------------"
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at:"`date`
echo "-----------------------------------------"

	##This script reduces the 138K cohort to a set of 58K unrelated participants and ##
	##removes ambiguous variants and those with MAF <1%.##

module load PLINK/2.00a2.3_x86_64

input=./data/GSAv2_CHIP/phased_vcfs_freeze150K/${SGE_TASK_ID}.phased.vcf.gz
data_dir=./data/QC_datasets/60K_files
IIDs=./pop_structure/data/IMPUTE5_Output/60K_analyses/vcf_RGN_numID_60K.txt

plink2 --vcf $input --keep $IIDs --exclude $data_dir/MT_60K_ambig_SNPs.txt --maf 0.01 --export vcf bgz \
--out $data_dir/Phased_Chr_files/MT_MCPS_60K_phased_MAF1pc_no_ambigs_chr${SGE_TASK_ID}


