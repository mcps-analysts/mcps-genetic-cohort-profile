#!/bin/bash
#$ -cwd
#$ -N MT_combining_IMPUTE5_60K_co-anc_tranches
#$ -q short.qc
#$ -pe shmem 28
#$ -o ./pop_structure/code/IMPUTE5/60K_analyses/logs/combining_co-anc_matrices_log_folder/MT_comb_60K_tranchesiv.out
#$ -e ./pop_structure/code/IMPUTE5/60K_analyses/logs/combining_co-anc_matrices_log_folder/MT_comb_60K_tranchesiv.err

echo "-----------------------------------------"
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at:"`date`
echo "-----------------------------------------"

      ##This script sums the four tranches into one overall nearest genetic neighbour matrix## 

data_dir=./pop_structure/data/IMPUTE5_Output/60K_analyses
code_dir=./pop_structure/code/IMPUTE5/60K_analyses

module load Python/3.7.4-GCCcore-8.3.0
module load SciPy-bundle/2020.03-foss-2019b-Python-3.7.4

for file in $data_dir/Tranche*/output/*co-anc_matrix.txt

do

if [ -e $data_dir/Final/MT_final_60K_co-anc_matrix.txt ] 
	then
		mv $data_dir/Final/MT_final_60K_co-anc_matrix.txt $data_dir/Final_holding/MT_final_holding_60K_co-anc_matrix.txt
		python $code_dir/00.3_Combining_60K_co-anc_tranches.py $file
		rm $data_dir/Final_holding/MT*_60K_co-anc_matrix.txt
	else 
		cp $file $data_dir/Final/MT_final_60K_co-anc_matrix.txt
	fi
done
