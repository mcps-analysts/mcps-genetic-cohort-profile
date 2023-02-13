#!/bin/bash
#$ -cwd
#$ -N MT_60K_SVD
#$ -q short.qc
#$ -pe shmem 36
#$ -o ./pop_structure/code/IMPUTE5/60K_analyses/logs/SVD/MT_MCPS_60K_SVD.out
#$ -e ./pop_structure/code/IMPUTE5/60K_analyses/logs/SVD/MT_MCPS_60K_SVD.err

echo "-----------------------------------------"
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at:"`date`
echo "-----------------------------------------"

data_dir=./pop_structure/data/IMPUTE5_Output
code_dir=./pop_structure/code/IMPUTE5/60K_analyses

module load R/4.1.0-foss-2021a
Rscript $code_dir/00.6_SVD_MCPS60K.R
