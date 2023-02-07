# module load R/3.6.2-foss-2019b

"%&%" <- function(a,b) paste0(a,b)
library("data.table")
library("tidyverse")
library("bigsnpr")
set.seed(1)

serv.dir <- "/well/emberson/users/bjk420/"
base.dir <- serv.dir %&% "projects/popgen/01_pca/global_inmegen/imputed-topmed/"
work.dir <- base.dir %&% "04_mais_rsq90/"
file.dir <- work.dir %&% "bigsnpr_output/"
plink.dir <- base.dir %&% "merged_mcps/"
plink.pre <- "merged_reference_rsq90.merge.mcps.autosomes"
bed.file <- plink.dir %&% plink.pre %&% ".bed"

plink2<-"/well/emberson/shared/software/plink2/plink2"

# Determine related pairs of individuals
##rel <- snp_plinkKINGQC(
##  plink2.path = plink2,
##  bedfile.in = bed.file,
##  thr.king = 0.0884,
##  make.bed = FALSE,
##  ncores = 32
#)
##str(rel)
##write.table(x=rel,file=file.dir %&% "bigsnpr_relationships.txt",sep="\t",quote=F,row.names=F)
## NOTE: Not enough memory for snp_plinkKINGQC command as written;
## Instead, running this command in the terminal:

plink2=/well/emberson/shared/software/plink2/plink2
basedir=/well/emberson/users/bjk420/projects/popgen/01_pca/global_inmegen/imputed-topmed
infile=$basedir/merged_mcps/merged_reference_rsq90.merge.mcps.autosomes
outfile=$basedir/04_mais_rsq90/bigsnpr_output/king
$plink2 \
  --bfile $infile \
  --king-table-filter 0.0884 --make-king-table \
  --out $outfile \
  --threads 32 --memory 201479571968



rel <- fread(file.dir %&% "king.kin0")
names(rel)[1] <- "FID1"
write.table(x=rel,file=file.dir %&% "bigsnpr_relationships.txt",sep="\t",quote=F,row.names=F)

# PCA
# Remove relateds from the bedfile object
(obj.bed <- bed(bed.file))
ind.rel <- match(c(rel$IID1, rel$IID2), obj.bed$fam$sample.ID)
ind.norel <- rows_along(obj.bed)[-ind.rel]
# Select a random set of 500 unrelated MCPS samples, and retain all unrelated reference samples
ind.norel.names <- obj.bed$fam$sample.ID[ind.norel]
ind.norel.refs <- ind.norel.names[!grepl("MCPS",ind.norel.names)]
ind.norel.mcps <- ind.norel.names[grepl("MCPS",ind.norel.names)]
ind.norel.mcps500 <- sample(ind.norel.mcps,500,replace=F)
keep.vec <- c(ind.norel.refs,ind.norel.mcps500)
match.vec <- match(keep.vec, obj.bed$fam$sample.ID)
keep.indices <- rows_along(obj.bed)[match.vec]
saveRDS(object=keep.vec,file=file.dir %&% "keep.vec.RDS")
saveRDS(object=keep.indices,file=file.dir %&% "keep.indices.RDS")

# Determine corresponding MAC threshold for MAF 1%
##num.chroms <- (obj.bed$fam$sample.ID %>% length(.)) * 2 # This line corresponds to ALL individuals
num.chroms <- length(keep.vec) * 2 # This line corresponds to all UNRELATED individuals
mac.threshold <- (0.01 * num.chroms) %>% round(.,0)
saveRDS(object=mac.threshold,file=file.dir %&% "mac.threshold.RDS") # MAC threshold = 89
# Run SVD algorithm
obj.svd <- bed_autoSVD(obj.bed, ind.row = keep.indices, k = 20, min.mac=mac.threshold,
                       ncores = 1)
saveRDS(object=obj.svd,file=file.dir %&% "svd_unrelateds_maf01.rds")

## Printed output from command:
## Phase of clumping (on MAC) at r^2 > 0.2..
## keep 96311 variants.
## Discarding 1296 variants with MAC < 89.
## Iteration 1:
## Computing SVD..
## 39 outlier variants detected..
## 1 long-range LD region detected..
## Iteration 2:
## Computing SVD..
## 0 outlier variant detected..
## Converged!
