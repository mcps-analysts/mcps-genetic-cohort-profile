BCFTOOLS=/apps/well/bcftools/1.4.1/bin/bcftools
REFDIR=./popgen/03_phasing
WORKDIR=./popgen/04_rfmix/including_mais_samples/three_way
VCFFILE=$REFDIR/output_files/merged_reference_rsq90_chr22_phased.vcf.gz
$BCFTOOLS query -l $VCFFILE > $WORKDIR/input_files/reference-sample-list.txt
