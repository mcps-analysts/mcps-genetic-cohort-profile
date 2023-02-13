#!/bin/bash
#$ -cwd
#$ -P emberson.prjc
#$ -N MT_IMPUTE5_MCPS_60K_whole_Chr_jobs
#$ -q short.qc@@short.hga
#$ -pe shmem 40
#$ -t 16-22:1
#$ -o ./pop_structure/code/IMPUTE5/60K_analyses/logs/whole_chr_jobs/
#$ -e ./pop_structure/code/IMPUTE5/60K_analyses/logs/whole_chr_jobs/

echo "-----------------------------------------"
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at:"`date`
echo "-----------------------------------------"

	##This script tries to run IMPUTE5 on chr16-22 to create co-ancestry matrices##
	##The separate matrices will subsequently be summed then standardised##

module load BCFtools/1.10.2-GCC-8.3.0

IMPUTE5_folder=./software/IMPUTE5/impute5_v1.1.4
map_folder=./pop_structure/input_data
ref_folder=./data/QC_datasets/60K_files/Phased_Chr_files/Imp5Files
input_folder=./data/QC_datasets/60K_files/Phased_Chr_files/
output_folder=./pop_structure/data/IMPUTE5_Output/60K_analyses

	#Running IMPUTE5 to create co-ancestry matrix with all 138K participants#

$IMPUTE5_folder/impute5_1.1.4_static --h $ref_folder/MT_MCPS_60K_chr${SGE_TASK_ID}.imp5 \
--m $map_folder/chr${SGE_TASK_ID}.b38.gmap.gz \
--g $input_folder/MT_MCPS_60K_phased_MAF1pc_no_ambigs_chr${SGE_TASK_ID}.vcf.gz --r ${SGE_TASK_ID} \
--o $output_folder/IMPUTED_chunks/MT_MCPS_60K_IMPUTE5_output_Chr${SGE_TASK_ID}.vcf.gz \
--ohapcopy $output_folder/Shared_genome_matrices/MT_MCPS_60K_hapcopy_Chr${SGE_TASK_ID}.shared \
--ban-repeated-sample-names

