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

WORKDIR=./popgen/04_rfmix/including_mais_samples/00_chromosomeX/
OUTDIR=$WORKDIR/merged_mais-hgdp-1kg
GMAPDIR=./popgen/03_phasing/gmap_files

mv $OUTDIR/merged_mais_rsq90.merge.merged_hgdp-1kg_chrX.bim \
 $OUTDIR/merged_reference_mais-rsq90.bim
mv $OUTDIR/merged_mais_rsq90.merge.merged_hgdp-1kg_chrX.bed \
 $OUTDIR/merged_reference_mais-rsq90.bed
mv $OUTDIR/merged_mais_rsq90.merge.merged_hgdp-1kg_chrX.fam \
 $OUTDIR/merged_reference_mais-rsq90.fam
mv $OUTDIR/merged_mais_rsq90.merge.merged_hgdp-1kg_chrX.nosex \
 $OUTDIR/merged_reference_mais-rsq90.nosex

FILEPRE=merged_reference_mais-rsq90

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
