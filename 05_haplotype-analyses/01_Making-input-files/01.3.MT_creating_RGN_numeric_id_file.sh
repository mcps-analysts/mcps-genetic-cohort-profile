#!/bin/bash
#$ -cwd
#$ -P emberson.prjc
#$ -N MT_creating_vcf_RGN_numID_60K
#$ -q short.qc
#$ -o ./data/QC_datasets/60K_files/logs/creating_vcf_RGN_numID_60K.out
#$ -e ./data/QC_datasets/60K_files/logs/creating_vcf_RGN_numID_60K.err

echo "-----------------------------------------"
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at:"`date`
echo "-----------------------------------------"

data_dir=./pop_structure/data/IMPUTE5_Output/60K_analyses
code_dir=./data/QC_datasets/60K_files

module load Python/3.7.4-GCCcore-8.3.0
module load SciPy-bundle/2020.03-foss-2019b-Python-3.7.4

python $code_dir/00.3_Creating_RGN_numID_file_for_60K.py
