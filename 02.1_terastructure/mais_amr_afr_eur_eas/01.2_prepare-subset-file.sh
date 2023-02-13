plink2=./shared/software/plink2/plink2
BASEDIR=./popgen
WORKDIR=$BASEDIR/02.1_terastructure/mais_amr_afr_eur_eas
INPUTDIR=$WORKDIR/input_files
GENDIR=$BASEDIR/01_pca/public_mais/merged_mais-hgdp-1kg
GENPRE=merged_reference_rsq90

$plink2 --bfile $GENDIR/$GENPRE --keep $INPUTDIR/subset-samples.txt \
  --make-bed --out $INPUTDIR/subset-samples
