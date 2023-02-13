#!/bin/bash
#$ -cwd
#$ -P emberson.prjc
#$ -N MT_combining_60K_IMPUTE5_output_tranche1-4
#$ -q long.qc
#$ -pe shmem 24
#$ -t 1-4:1
#$ -o ./pop_structure/code/IMPUTE5/60K_analyses/logs/combining_co-anc_matrices_log_folder/
#$ -e ./pop_structure/code/IMPUTE5/60K_analyses/logs/combining_co-anc_matrices_log_folder/

echo "-----------------------------------------"
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at:"`date`
echo "-----------------------------------------"

data_dir=./pop_structure/data/IMPUTE5_Output/60K_analyses/Tranche"${SGE_TASK_ID}"
code_dir=./pop_structure/code/IMPUTE5/60K_analyses

module load Python/3.7.4-GCCcore-8.3.0
module load SciPy-bundle/2020.03-foss-2019b-Python-3.7.4

for file in $data_dir/compressed/comp_*.sharedlength

do

	if [ -e $data_dir/output/MT_60K_Tranche"${SGE_TASK_ID}"_summed_co-anc_matrix.txt ]
		then
			mv $data_dir/output/MT_60K_Tranche"${SGE_TASK_ID}"_summed_co-anc_matrix.txt $data_dir/holding/MT_60K_Tranche"${SGE_TASK_ID}"_summed_co-anc_matrix.txt
			python $code_dir/Combining_60K_co-ancestry_matrices_step2.py $file ${SGE_TASK_ID}
			rm $data_dir/holding/*
		else
			cp $file $data_dir/output/MT_60K_Tranche"${SGE_TASK_ID}"_summed_co-anc_matrix.txt
			echo "Master co-ancestry matrix created."
	fi

done
