#!/bin/bash
#$ -cwd
#$ -N chrX_shapeit4
#$ -q short.qc
#$ -o logs/chrX_shapeit4.out
#$ -e logs/chrX_shapeit4.err
#$ -pe shmem 2

echo "------------------------------------------------"
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at: "`date`
echo "------------------------------------------------"

module load BCFtools/1.10.2-GCC-8.3.0
module load SHAPEIT4/4.1.3-foss-2019b
PLINK2=./shared/software/plink2/plink2
TABIX=/apps/well/tabix/0.2.6/tabix

WORKDIR=popgen/sex_chromosomes
OUTDIR=$WORKDIR/merged
GMAPDIR=popgen/03_phasing/gmap_files
FILEPRE=merged_hgdp-1kg_chrX

$PLINK2 --bfile $OUTDIR/$FILEPRE \
     --export vcf bgz id-paste=iid \
     --out $OUTDIR/$FILEPRE
$TABIX -p vcf -f $OUTDIR/$FILEPRE.vcf.gz

shapeit4 --input $OUTDIR/$FILEPRE.vcf.gz  \
    --map $GMAPDIR/chrX.b38.gmap.gz  \
    --region X  -T 16  \
    --output $OUTDIR/$FILEPRE-phased.vcf \
    --log $WORKDIR/logs/shapeit4_chrX.log

bgzip -c $OUTDIR/$FILEPRE-phased.vcf > $OUTDIR/$FILEPRE-phased.vcf.gz
bcftools index $OUTDIR/$FILEPRE-phased.vcf.gz
