#!/bin/bash
#$ -cwd
#$ -P emberson.prjc
#$ -N MT_IMPUTE5_MCPS_60K_chr2p
#$ -q short.qc@@short.hga
#$ -pe shmem 44
#$ -o ./code/IMPUTE5/60K_analyses/logs/MT_IMPUTE5_60K_2p.out
#$ -e ./code/IMPUTE5/60K_analyses/logs/MT_IMPUTE5_60K_2p.err

echo "-----------------------------------------"
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at:"`date`
echo "-----------------------------------------"

	##This script tries to run IMPUTE5 on chr2 p to create a co-ancestry matrix##
	##The separate matrices will subsequently be summed then standardised##

module load BCFtools/1.10.2-GCC-8.3.0

IMPUTE5_folder=./software/IMPUTE5/impute5_v1.1.4
map_folder=./pop_structure/input_data
ref_folder=./data/QC_datasets/60K_files/Phased_Chr_files/Imp5Files
input_folder=./data/QC_datasets/60K_files/Phased_Chr_files/
output_folder=./data/IMPUTE5_Output/60K_analyses
chr=2

	#Running IMPUTE5 to create co-ancestry matrix with all 138K participants#

$IMPUTE5_folder/impute5_1.1.4_static --h $ref_folder/MT_MCPS_60K_chr$chr.imp5 \
--m $map_folder/chr$chr.b38.gmap.gz \
--g $input_folder/MT_MCPS_60K_phased_MAF1pc_no_ambigs_chr$chr.vcf.gz --r $chr:1-90000000 \
--o $output_folder/IMPUTED_chunks/MT_MCPS_60K_IMPUTE5_output_Chr$chr.p.vcf.gz \
--ohapcopy $output_folder/Shared_genome_matrices/MT_MCPS_60K_hapcopy_Chr$chr.p.shared \
--ban-repeated-sample-names
