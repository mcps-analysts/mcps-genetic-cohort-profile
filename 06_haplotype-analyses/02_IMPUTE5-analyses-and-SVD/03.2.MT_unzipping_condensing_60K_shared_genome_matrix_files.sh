#!/bin/bash
#$ -cwd
#$ -P emberson.prjc
#$ -N MT_unzipping_condensing_60K_co-anc_matrices
#$ -q long.qc
#$ -pe shmem 36
#$ -t 1-4:1
#$ -o ./pop_structure/code/IMPUTE5/60K_analyses/logs/Unzipping_condensing_co-anc_matrices_log_folder/
#$ -e ./pop_structure/code/IMPUTE5/60K_analyses/logs/Unzipping_condensing_co-anc_matrices_log_folder/

echo "-----------------------------------------"
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at:"`date`
echo "-----------------------------------------"

	##This code unzips and condenses all the zipped hapcopy files in parallel##

data_dir=./pop_structure/data/IMPUTE5_Output/60K_analyses/Tranche${SGE_TASK_ID}
code_dir=./pop_structure/code/IMPUTE5/60K_analyses

module load Python/3.7.4-GCCcore-8.3.0
module load SciPy-bundle/2020.03-foss-2019b-Python-3.7.4

mkdir $data_dir/Shared_genome_matrices
mkdir $data_dir/Unzipped_genome_matrices
mkdir $data_dir/compressed
mkdir $data_dir/holding
mkdir $data_dir/output

for file in $data_dir/Shared_genome_matrices/MT_MCPS*.shared.gz

do

gunzip -cd $file > $data_dir/Unzipped_genome_matrices/$(basename "$file" .shared.gz).sharedlength
python $code_dir/Combining_60K_co-ancestry_matrices_step1.py $data_dir/Unzipped_genome_matrices/$(basename $file .shared.gz).sharedlength ${SGE_TASK_ID}
rm $data_dir/Unzipped_genome_matrices/MT*.sharedlength

if [ -e $data_dir/output/MT_60K_Tranche"${SGE_TASK_ID}"_summed_co-anc_matrix.txt ]
	then
		mv $data_dir/output/MT_60K_Tranche"${SGE_TASK_ID}"_summed_co-anc_matrix.txt $data_dir/holding/MT_60K_Tranche"${SGE_TASK_ID}"_summed_co-anc_matrix.txt
		python $code_dir/Combining_60K_co-ancestry_matrices_step2.py $data_dir/compressed/comp_$(basename "$file" .shared.gz).shared.length ${SGE_TASK_ID}
		rm $data_dir/holding/*
	else
		cp $data_dir/compressed/comp_$(basename "$file" .shared.gz).sharedlength $data_dir/output/MT_60K_Tranche"${SGE_TASK_ID}"_summed_co-anc_matrix.txt
		echo "Master co-ancestry matrix created."
	fi

done
