# module load R/3.6.2-foss-2019b

"%&%" <- function(a,b) paste0(a,b)
library("data.table")
library("tidyverse")
library("bigsnpr")
set.seed(1)

serv.dir <- ""
work.dir <- serv.dir %&% "projects/popgen/01_pca/global/"
file.dir <- work.dir %&% "bigsnpr_output/"
plink.dir <- work.dir %&% "merged_mcps/"
plink.pre <- "merged_mcps-hgdp-1kg"
bed.file <- plink.dir %&% plink.pre %&% ".bed"


plink2<-"/apps/well/plink/2.00a-20170724/plink2"

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

#/well/emberson/shared/software/plink2/plink2 \
#  --bfile projects/popgen/01_pca/global/merged_mcps/merged_mcps-hgdp-1kg \
#  --king-table-filter 0.0884 --make-king-table \
#  --out projects/popgen/01_pca/global/bigsnpr_output/king \
#  --threads 32 --memory 201479571968

rel <- fread(file.dir %&% "king.kin0")
names(rel)[1] <- "FID1"
write.table(x=rel,file=file.dir %&% "bigsnpr_relationships.txt",sep="\t",quote=F,row.names=F)

# PCA
# Remove relateds from the bedfile object
(obj.bed <- bed(bed.file))
ind.rel <- match(c(rel$IID1, rel$IID2), obj.bed$fam$sample.ID)
ind.norel <- rows_along(obj.bed)[-ind.rel]
# Select a random set of 100 unrelated MCPS samples, and retain all unrelated reference samples
ind.norel.names <- obj.bed$fam$sample.ID[ind.norel]
ind.norel.refs <- ind.norel.names[!grepl("MCPS",ind.norel.names)]
ind.norel.mcps <- ind.norel.names[grepl("MCPS",ind.norel.names)]
ind.norel.mcps100 <- sample(ind.norel.mcps,100,replace=F)
keep.vec <- c(ind.norel.refs,ind.norel.mcps100)
match.vec <- match(keep.vec, obj.bed$fam$sample.ID)
keep.indices <- rows_along(obj.bed)[match.vec]
saveRDS(object=keep.vec,file=file.dir %&% "keep.vec.RDS")
saveRDS(object=keep.indices,file=file.dir %&% "keep.indices.RDS")

# Determine corresponding MAC threshold for MAF 1%
num.chroms <- length(keep.vec) * 2 # This line corresponds to all UNRELATED individuals
mac.threshold <- (0.01 * num.chroms) %>% round(.,0)
saveRDS(object=mac.threshold,file=file.dir %&% "mac.threshold.RDS") # MAC threshold = 70
# Run SVD algorithm
obj.svd <- bed_autoSVD(obj.bed, ind.row = keep.indices, k = 20, min.mac=mac.threshold,
                       ncores = 1)
saveRDS(object=obj.svd,file=file.dir %&% "svd_unrelateds_maf01.rds")
