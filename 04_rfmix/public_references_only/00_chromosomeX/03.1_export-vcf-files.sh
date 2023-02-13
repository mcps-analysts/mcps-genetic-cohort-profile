PLINK1=./shared/software/plink1/plink
PLINK2=./shared/software/plink2/plink2
TABIX=/apps/well/tabix/0.2.6/tabix
BCFTOOLS=./shared/software/bcftools/bcftools/bcftools

INDIR=./popgen/04_rfmix/public_references_only/00_chromosomeX/merged_mcps
OUTDIR=./popgen/04_rfmix/public_references_only/00_chromosomeX/merged_mcps

### Chromosome X
name1='merged_hgdp-1kg_chrX'
name2='MCPS_Freeze_150.GT_hg38.pVCF'
FILEPRE=$name1.merge.$name2
mv $OUTDIR/$FILEPRE.fam $OUTDIR/$FILEPRE.fam_ORIG
module load R/3.6.2-foss-2019b
Rscript popgen/04_rfmix/public_references_only/00_chromosomeX/03.0_modify-fam-sex.R
## Export VCF file
$PLINK2 --bfile $OUTDIR/$FILEPRE \
     --export vcf bgz id-paste=iid \
     --out $OUTDIR/$FILEPRE
$TABIX -p vcf -f $OUTDIR/$FILEPRE.vcf.gz
