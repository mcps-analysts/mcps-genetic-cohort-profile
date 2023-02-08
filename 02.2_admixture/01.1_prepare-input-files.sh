SERVDIR=popgen
CURDIR=$SERVDIR/02.2_admixture/afr_eas_eur_mais_amr-select-mcps1k
PLINK2=shared/software/plink2/plink2

$PLINK2 --bfile  $CURDIR/input_files/full --keep $CURDIR/input_files/subset-samples.txt \
  --make-bed --out  $CURDIR/input_files/ref
$PLINK2 --bfile  $CURDIR/input_files/full --remove $CURDIR/input_files/subset-samples.txt \
  --make-bed --out  $CURDIR/input_files/mcps150k
