#!/bin/bash
#$ -cwd
#$ -P emberson.prjc
#$ -N MT_creating_60K_IID_file
#$ -q short.qc
#$ -pe shmem 6
#$ -o ./pop_structure/code/IMPUTE5/60K_analyses/logs/Creating_60K_IID_file.out
#$ -e ./pop_structure/code/IMPUTE5/60K_analyses/logs/Creating_60K_IID_file.err

echo "-----------------------------------------"
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at:"`date`
echo "-----------------------------------------"

data_dir=./pop_structure/data/IMPUTE5_Output/60K_analyses
code_dir=./pop_structure/code/IMPUTE5/60K_analyses

module load Python/3.7.4-GCCcore-8.3.0
module load SciPy-bundle/2020.03-foss-2019b-Python-3.7.4

file=$data_dir/Tranche1/Shared_genome_matrices/MT_MCPS_60K_hapcopy_Chr2.p.shared.gz

gunzip -cd $file > $data_dir/Tranche1/Unzipped_genome_matrices/$(basename "$file" .shared.gz).sharedlength
python $code_dir/Creating_60K_IID_file.py $data_dir/Tranche1/Unzipped_genome_matrices/$(basename "$file" .shared.gz).sharedlength
