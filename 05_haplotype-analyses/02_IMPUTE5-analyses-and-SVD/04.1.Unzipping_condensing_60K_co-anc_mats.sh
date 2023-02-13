#!/bin/bash
#$ -cwd
#$ -N MT_unzipping_condensing_60K_IMPUTE5_output_tranche1-4
#$ -q himem.qh
#$ -pe shmem 12
#$ -t 1-4:1
#$ -o ./pop_structure/code/IMPUTE5/60K_analyses/logs/combining_co-anc_matrices_log_folder/
#$ -e ./pop_structure/code/IMPUTE5/60K_analyses/logs/combining_co-anc_matrices_log_folder/

echo "-----------------------------------------"
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at:"`date`
echo "-----------------------------------------"

      ##Unzip and the condense per-haplotype nearest genetic neighbour matrices##
      ##into per-individidual nearest genetic neighbour matrices               ##

data_dir=./pop_structure/data/IMPUTE5_Output/60K_analyses
code_dir=./pop_structure/code/IMPUTE5/60K_analyses

module load Python/3.7.4-GCCcore-8.3.0
module load SciPy-bundle/2020.03-foss-2019b-Python-3.7.4

for file in $data_dir/Tranche"${SGE_TASK_ID}"/Shared_genome_matrices/MT*.shared.gz

do
	gunzip -cd $file > $data_dir/Tranche"${SGE_TASK_ID}"/Unzipped_genome_matrices/$(basename "$file" .shared.gz).sharedlength
	python $code_dir/00.1_Combining_60K_co-ancestry_matrices_step1.py $data_dir/Tranche"${SGE_TASK_ID}"/Unzipped_genome_matrices/$(basename "$file" .shared.gz).sharedlength ${SGE_TASK_ID}

done 
