#!/bin/bash
#$ -cwd
#$ -P emberson.prjc
#$ -N MT_creating_ambig_list
#$ -q short.qc
#$ -o ./data/QC_datasets/60K_files/logs/creating_ambig_list4.out
#$ -e ./data/QC_datasets/60K_files/logs/creating_ambig_list4.err

echo "-----------------------------------------"
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at:"`date`
echo "-----------------------------------------"

code_dir=./data/QC_datasets/60K_files

module load Python/3.7.4-GCCcore-8.3.0
module load SciPy-bundle/2020.03-foss-2019b-Python-3.7.4

python $code_dir/00.4_Creating_list_of_ambiguous_SNP_rsIDs_from_MCPS60K.py
