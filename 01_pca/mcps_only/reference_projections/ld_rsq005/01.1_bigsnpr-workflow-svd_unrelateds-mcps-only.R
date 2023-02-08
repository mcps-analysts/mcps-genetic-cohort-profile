# module load R/3.6.2-foss-2019b

"%&%" <- function(a,b) paste0(a,b)
library("data.table")
library("tidyverse")
library("bigsnpr")

serv.dir <- ""
work.dir0 <- serv.dir %&% "projects/popgen/01_pca/public_mais/04_mais_rsq90/"
work.dir <- serv.dir %&% "projects/popgen/01_pca/mcps_only/" %&%
  "reference_projections/ld_rsq005/"
base.dir <- serv.dir %&% "projects/popgen/01_pca/public_mais/"
file.dir <- work.dir %&% "bigsnpr_output/"
plink.dir <- base.dir %&% "merged_mcps/"
plink.pre <- "merged_reference_rsq90.merge.mcps.autosomes"
bed.file <- plink.dir %&% plink.pre %&% ".bed"

rel <- fread(work.dir0 %&% "bigsnpr_output/bigsnpr_relationships.txt")

# PCA
# Remove relateds from the bedfile object
(obj.bed <- bed(bed.file))
ind.rel <- match(c(rel$IID1, rel$IID2), obj.bed$fam$sample.ID)
reference.samples <- obj.bed$fam$sample.ID[!grepl("MCPS",obj.bed$fam$sample.ID)]
reference.index <- c(1:length(obj.bed$fam$sample.ID))[obj.bed$fam$sample.ID %in% reference.samples]
remove.samples <- c(ind.rel,reference.index) %>% unique(.)
keep.indices <- rows_along(obj.bed)[-remove.samples]
keep.vec <- obj.bed$fam$sample.ID[keep.indices]
saveRDS(object=keep.vec,file=file.dir %&% "keep.vec.RDS")
saveRDS(object=keep.indices,file=file.dir %&% "keep.indices.RDS")
# Determine corresponding MAC threshold for MAF 1%
##num.chroms <- (obj.bed$fam$sample.ID %>% length(.)) * 2 # This line corresponds to ALL individuals
num.chroms <- length(keep.vec) * 2 # This line corresponds to all UNRELATED individuals
mac.threshold <- (0.01 * num.chroms) %>% round(.,0) # MAC = 1169
saveRDS(object=mac.threshold,file=file.dir %&% "mac.threshold.RDS")

# Run SVD algorithm
obj.svd <- bed_autoSVD(obj.bed, ind.row = keep.indices, k = 20, min.mac=mac.threshold,
                       ncores = 1, thr.r2 = 0.005)
saveRDS(object=obj.svd,file=file.dir %&% "svd_unrelateds_maf01-mcps-only.rds")

#Phase of clumping (on MAC) at r^2 > 0.005.. keep 14654 variants.
#Discarding 985 variants with MAC < 1169.
#Iteration 1:
#Computing SVD..
#0 outlier variant detected..
#Converged!
