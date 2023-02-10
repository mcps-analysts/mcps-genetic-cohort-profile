BCFTOOLS=/apps/well/bcftools/1.4.1/bin/bcftools
WORKDIR=/popgen/04_rfmix/including_mais_samples/three_way
VCFFILE=$WORKDIR/input_files/22.phased.vcf.gz
$BCFTOOLS query -l $VCFFILE > $WORKDIR/input_files/mcps-samples.txt
