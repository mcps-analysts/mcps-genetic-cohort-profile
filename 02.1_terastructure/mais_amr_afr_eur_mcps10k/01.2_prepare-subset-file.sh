# Script for subsetting mcps (qcd2) and public reference merged dataset to
# include only mcps samples present in WGS dataset

plink2=./shared/software/plink2/plink2

BASEDIR=popgen
WORKDIR=$BASEDIR/02.1_terastructure/mais_amr_afr_eur_mcps10k
INPUTDIR=$WORKDIR/input_files
GENDIR=$BASEDIR/01_pca/public_mais/merged_mcps
GENPRE=merged_reference_rsq90.merge.mcps.autosomes

$plink2 --bfile $GENDIR/$GENPRE --keep $INPUTDIR/subset-samples.txt \
  --make-bed --out $INPUTDIR/subset-samples
