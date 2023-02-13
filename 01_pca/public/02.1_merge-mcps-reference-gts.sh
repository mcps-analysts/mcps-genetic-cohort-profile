
module load Python/3.7.4-GCCcore-8.3.0
plink=./shared/software/plink2/plink2
plink1=./shared/software/plink1/plink

### Create sub directories
workdir=./popgen/01_pca/public

datadir1=$workdir/merged
datadir2=./projects/mcps/data/genetics_regeneron/freeze_150k/data/GSAv2_CHIP/pVCF/qcd2

mkdir $workdir/merged_mcps
mergedir=$workdir/merged_mcps

#name1='merged_hgdp-1kg_qcd' # Use if post-merge qc'd file is desired
name1='merged_hgdp-1kg'
name2='MCPS_Freeze_150.GT_hg38.pVCF.qcd2'


### Filter reference and study data for non A-T or G-C SNPs
echo 'Filter reference and study data for non AT or GC SNPs'
awk 'BEGIN {OFS="\t"}  ($5$6 == "GC" || $5$6 == "CG" \
                        || $5$6 == "AT" || $5$6 == "TA")  {print $2}' \
    $datadir1/$name1.bim > \
    $mergedir/$name1.ac_gt_snps

awk 'BEGIN {OFS="\t"}  ($5$6 == "GC" || $5$6 == "CG" \
                        || $5$6 == "AT" || $5$6 == "TA")  {print $2}' \
    $datadir2/$name2.bim > \
    $mergedir/$name2.ac_gt_snps
mkdir $mergedir/plink_log/

$plink1 --bfile $datadir1/$name1 \
      --exclude $mergedir/$name1.ac_gt_snps \
      --make-bed \
      --out $mergedir/$name1.no_ac_gt_snps
mv $mergedir/$name1.no_ac_gt_snps.log $mergedir/plink_log/$name1.no_ac_gt_snps.log

$plink1 --bfile $datadir2/$name2 \
      --exclude $mergedir/$name2.ac_gt_snps \
      --make-bed \
      --out $mergedir/$name2.no_ac_gt_snps
mv $mergedir/$name2.no_ac_gt_snps.log $mergedir/plink_log/$name2.no_ac_gt_snps.log

### Filter reference data for the same SNP set as in study
echo 'Filter reference data for the same SNP set as in study'
$plink1 --bfile $datadir2/$name2 \
      --extract $mergedir/$name1.no_ac_gt_snps.bim \
      --make-bed \
      --out $mergedir/$name2.pruned
mv $mergedir/$name2.pruned.log $mergedir/plink_log/$name2.pruned.log

$plink1 --bfile $datadir1/$name1 \
      --extract $mergedir/$name2.no_ac_gt_snps.bim \
      --make-bed \
      --out $mergedir/$name1.pruned
mv $mergedir/$name1.pruned.log $mergedir/plink_log/$name1.pruned.log


### Position mismatch
echo 'Position mismatch evaluate'
awk 'BEGIN {OFS="\t"} FNR==NR {a[$2]=$4; next} \
    ($2 in a && a[$2] != $4) {print a[$2],$2}' \
    $mergedir/$name1.pruned.bim $mergedir/$name2.pruned.bim > \
    $mergedir/${name2}.toUpdatePos

### Possible allele flips
echo 'Evaluate possible allele flips'
awk 'BEGIN {OFS="\t"} FNR==NR {a[$1$2$4]=$5$6; next} \
    ($1$2$4 in a && a[$1$2$4] != $5$6 && a[$1$2$4] != $6$5) {print $2}' \
    $mergedir/$name1.pruned.bim $mergedir/$name2.pruned.bim > \
    $mergedir/$name2.toFlip

### Update positions and flip alleles
echo 'Update positions and flip alleles'
$plink1 --bfile $mergedir/$name2.pruned \
       --flip $mergedir/$name2.toFlip \
       --make-bed \
       --out $mergedir/$name2.flipped
mv $mergedir/$name2.flipped.log $mergedir/plink_log/$name2.flipped.log

### Remove mismatches
echo 'Remove mismatches'
awk 'BEGIN {OFS="\t"} FNR==NR {a[$1$2$4]=$5$6; next} \
    ($1$2$4 in a && a[$1$2$4] != $5$6 && a[$1$2$4] != $6$5) {print $2}' \
    $mergedir/$name1.pruned.bim $mergedir/$name2.flipped.bim > \
    $mergedir/$name2.mismatch

$plink1 --bfile $mergedir/$name2.flipped \
       --exclude $mergedir/$name2.mismatch \
       --make-bed \
       --out $mergedir/$name2.clean
mv $mergedir/$name2.clean.log $mergedir/plink_log/$name2.clean.log

cat $mergedir/$name2.clean.bim | cut -f 2 | uniq -d > $mergedir/$name2.dup.snps

$plink1 --bfile $mergedir/$name2.clean \
       --exclude $mergedir/$name2.dup.snps \
       --make-bed \
       --out $mergedir/$name2.cleaner
mv $mergedir/$name2.cleaner.log $mergedir/plink_log/$name2.cleaner.log

## note: found evidence of 0 duplicated SNP ids; attributable to indels and snvs sharing same start coordinate positions

### Merge study genotypes and reference data
echo 'Merge study genotypes and reference data'
cat $mergedir/$name2.cleaner.bim | cut -f 2 > $mergedir/$name2.cleaner.snps
$plink1 --bfile $mergedir/$name1.pruned \
       --extract $mergedir/$name2.cleaner.snps \
       --make-bed \
       --out $mergedir/$name1.cleaner

$plink1 --bfile $mergedir/$name1.cleaner \
      --bmerge $mergedir/$name2.cleaner.bed $mergedir/$name2.cleaner.bim \
        $mergedir/$name2.cleaner.fam \
      --make-bed \
      --threads 16 \
      --out $mergedir/$name1.merge.$name2
      
mv $mergedir/$name1.merge.$name2.log $mergedir/plink_log
