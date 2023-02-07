# module load R/3.6.2-foss-2019b

## Note: Not necessary to re-run as did not find 
## compelling evidence for outliers in step 03.2, 
## code is left as reference for future analyses

"%&%" <- function(a,b) paste0(a,b)
library("data.table")
library("tidyverse")
library("bigsnpr")

serv.dir <- ""
work.dir <- serv.dir %&% "popgen/pca/global/"
file.dir <- work.dir %&% "bigsnpr_output/"
plink.dir <- work.dir %&% "merged_mcps/"
plink.pre <- "merged_mcps-hgdp-1kg_qcd"
bed.file <- plink.dir %&% plink.pre %&% ".bed"

obj.svd <- readRDS(file.dir %&% "svd_unrelateds_maf01.rds")
S <- readRDS(file.dir %&% "knn-dist-stats_unrelateds_maf01.rds")

# PCA
## Remove relateds from the bedfile object
(obj.bed <- bed(bed.file))
keep.vec <- readRDS(file.dir %&% "keep.vec.RDS")
keep.indices <- readRDS(file.dir %&% "keep.indices.RDS")
mac.threshold <- readRDS(file.dir %&% "mac.threshold.RDS")

# PCA without outliers
ind.row <- keep.indices[S < 1]
ind.col <- attr(obj.svd, "subset")
obj.svd2 <- bed_autoSVD(obj.bed, ind.row = ind.row,min.mac=mac.threshold,
                        ind.col = ind.col, thr.r2 = NA,
                        k = 20, ncores = 1)
saveRDS(object=obj.svd2,file=file.dir %&% "svd2_unrelateds_maf01.rds")
