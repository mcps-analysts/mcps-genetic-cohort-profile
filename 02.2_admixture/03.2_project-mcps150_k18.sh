#!/bin/bash
#$ -wd popgen/02.2_admixture/afr_eas_eur_mais_amr-select-mcps1k/output_files/
#$ -N K_18-mcps150k-project-admix
#$ -q long.qc
#$ -o popgen/02.2_admixture/afr_eas_eur_mais_amr-select-mcps1k/logs/mcps150k-project-admix_k18.out
#$ -e popgen/02.2_admixture/afr_eas_eur_mais_amr-select-mcps1k/logs/mcps150k-project-admix_k18.err
#$ -pe shmem 24

echo "------------------------------------------------"
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at: "`date`
echo "------------------------------------------------"

WORKDIR=popgen/02.2_admixture/afr_eas_eur_mais_amr-select-mcps1k
K=18

## Copy .P file that corresponds to best K value on reference set
cp $WORKDIR/output_files/ref.$K.P $WORKDIR/output_files/mcps150k.$K.P.in
cp $WORKDIR/input_files/mcps150k* $WORKDIR/output_files/
## Run projection ADMIXTURE on full study set
shared/software/admixture_1.3.0/dist/admixture_linux-1.3.0/admixture \
  -P mcps150k.bed $K
