#!/bin/bash
#$ -cwd
#$ -N MT_IMPUTE5_MCPS_60K_chr7qii
#$ -q long.qc
#$ -pe shmem 44
#$ -o ./pop_structure/code/IMPUTE5/60K_analyses/logs/MT_IMPUTE5_60K_7qii.out
#$ -e ./pop_structure/code/IMPUTE5/60K_analyses/logs/MT_IMPUTE5_60K_7qii.err

echo "-----------------------------------------"
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at:"`date`
echo "-----------------------------------------"

	##This script tries to run IMPUTE5 on chr7q to create a co-ancestry matrix##
	##The separate matrices will subsequently be summed then standardised##

module load BCFtools/1.10.2-GCC-8.3.0

IMPUTE5_folder=./software/IMPUTE5/impute5_v1.1.4
map_folder=./pop_structure/input_data
ref_folder=./data/QC_datasets/60K_files/Phased_Chr_files/Imp5Files
input_folder=./data/QC_datasets/60K_files/Phased_Chr_files/
output_folder=./pop_structure/data/IMPUTE5_Output/60K_analyses
chr=7

	#Running IMPUTE5 to create co-ancestry matrix with all 60K participants#

$IMPUTE5_folder/impute5_1.1.4_static --h $ref_folder/MT_MCPS_60K_chr$chr.imp5 \
--m $map_folder/chr$chr.b38.gmap.gz \
--g $input_folder/MT_MCPS_60K_phased_MAF1pc_no_ambigs_chr$chr.vcf.gz --r $chr:60000001-159400000 \
--o $output_folder/IMPUTED_chunks/MT_MCPS_60K_IMPUTE5_output_Chr$chr.q.vcf.gz \
--ohapcopy $output_folder/Shared_genome_matrices/MT_MCPS_60K_hapcopy_Chr$chr.q.shared \
--ban-repeated-sample-names

