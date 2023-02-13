#!/bin/bash
#$ -cwd
#$ -N MT_MCPS_selecting_60K_pruning_MAF
#$ -q short.qc
#$ -pe shmem 4
#$ -o ./data/QC_datasets/60K_files/logs/MT_MCPS_60K_MAF4.out
#$ -e ./data/QC_datasets/60K_files/logs/MT_MCPS_60K_MAF4.err

echo "-----------------------------------------"
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at:"`date`
echo "-----------------------------------------"

	##This script reduces the 138K cohort to 58K unrelated participants then ##
        ##checks that no pairs of individuals have KING kinship <0.0884, then    ##
        ##removes variants with MAF < 1%##

module load PLINK/2.00a2.3_x86_64

input=./imputed-topmed/mcps/geno_files/mcps.autosomes
data_dir=./data/QC_datasets/60K_files
IIDs=./pop_structure/data/IMPUTE5_Output/60K_analyses/FIDs_IIDs_60K.txt

#subset
plink2 --bfile $input --keep $IIDs --make-bed --out $data_dir/MT_MCPS_60K_subset

#check relatedness
plink2 --bfile $data_dir/MT_MCPS_60K_subset --make-king-table \
--king-table-filter 0.0884 --out $data_dir/MT_MCPS_60K_0.0884_KING_pairs
#no pairs of related individuals remain#

#remove variants with MAF <1%
plink2 --bfile $data_dir/MT_MCPS_60K_subset --maf 0.01 --make-bed --out $data_dir/MT_MCPS_60K_MAF1pc

