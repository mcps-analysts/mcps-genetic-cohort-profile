#!/bin/bash
#$ -cwd
#$ -N chrX_rf7_em10
#$ -q long.qc
#$ -o logs/chrX_rf7_em10.out
#$ -e logs/chrX_rf7_em10.err
#$ -pe shmem 22

echo "------------------------------------------------"
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at: "`date`
echo "------------------------------------------------"

module load BCFtools/1.10.2-GCC-8.3.0

shared/software/rfmix/rfmix -f popgen/04_rfmix/including_mais_samples/seven_way/input_files/X.phased.vcf.gz \
    -r popgen/04_rfmix/including_mais_samples/seven_way/input_files/ref.cohort.chrX.recode.vcf.gz \
    --chromosome=X   -m popgen/04_rfmix/including_mais_samples/seven_way/input_files/ref-map-chrX.txt \
    -g popgen/04_rfmix/including_mais_samples/seven_way/gmap_files/chrX.b38.reformat.gmap \ 
    -n 5 -e 10   --debug=1 -G 15   -num-threads 16 \
    -o popgen/04_rfmix/including_mais_samples/seven_way/output_files/mcps.rfmix.chrX
