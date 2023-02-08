#!/bin/bash
#$ -cwd
#$ -N prepare-plot-files
#$ -q short.qc
#$ -o popgen/02.2_admixture/afr_eas_eur_mais_amr-select-mcps1k/logs/prepare-plot-files.out
#$ -e popgen/02.2_admixture/afr_eas_eur_mais_amr-select-mcps1k/logs/prepare-plot-files.err
#$ -pe shmem 2

echo "------------------------------------------------"
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at: "`date`
echo "------------------------------------------------"

module load R/3.6.2-foss-2019b

BASEDIR=popgen/02.2_admixture
BASEDIR=$BASEDIR/afr_eas_eur_mais_amr-select-mcps1k
RSCRIPT=$BASEDIR/04.0_prepare-plot-files.R

Rscript --vanilla $RSCRIPT
