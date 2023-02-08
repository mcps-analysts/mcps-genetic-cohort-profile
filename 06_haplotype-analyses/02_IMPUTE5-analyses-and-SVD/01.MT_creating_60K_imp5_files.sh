#!/bin/bash
#$ -cwd
#$ -N MT_IMPUTE5_creating_60K_imp5_files2
#$ -q short.qc
#$ -pe shmem 4
#$ -o ./code/IMPUTE5/60K_analyses/logs/MT_60K_imp5_files2.out
#$ -e ./code/IMPUTE5/60K_analyses/logs/MT_60K_imp5_files2.err

echo "-----------------------------------------"
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at:"`date`
echo "-----------------------------------------"

	##This script tries generates imp5 files for the 60K subset phased chr files##

module load BCFtools/1.10.2-GCC-8.3.0

IMPUTE5_folder=./software/IMPUTE5/impute5_v1.1.4
map_folder=./pop_structure/input_data
ref_folder=./data/QC_datasets/60K_files/Phased_Chr_files/Imp5Files
input_folder=./data/QC_datasets/60K_files/Phased_Chr_files
output_folder=./data/IMPUTE5_Output/60K_analyses

for num in {1..22}

do

bcftools index $input_folder/MT_MCPS_60K_phased_MAF1pc_no_ambigs_chr$num.vcf.gz
$IMPUTE5_folder/imp5Converter_1.1.4_static --h $input_folder/MT_MCPS_60K_phased_MAF1pc_no_ambigs_chr$num.vcf.gz \
--r $num --o $ref_folder/MT_MCPS_60K_chr$num.imp5

done

