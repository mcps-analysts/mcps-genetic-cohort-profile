#!/bin/bash
#$ -cwd
#$ -P emberson.prjc
#$ -N MT_formatting_60K_IID_file
#$ -q short.qc
#$ -o ./pop_structure/code/IMPUTE5/Second_full_trial/logs/Formatting_60K_IID_file.out
#$ -e ./pop_structure/code/IMPUTE5/Second_full_trial/logs/Formatting_60K_IID_file.err

echo "-----------------------------------------"
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at:"`date`
echo "-----------------------------------------"

data_dir=./pop_structure/data/IMPUTE5_Output/60K_analyses/Shared_genome_matrices
code_dir=./pop_structure/code/IMPUTE5/60K_analyses

module load Python/3.7.4-GCCcore-8.3.0
module load SciPy-bundle/2020.03-foss-2019b-Python-3.7.4

python $code_dir/Formatting_60K_IID_file.py 
