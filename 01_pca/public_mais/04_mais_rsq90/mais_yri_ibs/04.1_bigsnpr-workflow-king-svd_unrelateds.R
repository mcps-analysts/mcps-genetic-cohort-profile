# module load R/3.6.2-foss-2019b

"%&%" <- function(a,b) paste0(a,b)
library("data.table")
library("tidyverse")
library("bigsnpr")
set.seed(1)

serv.dir <- ""
base.dir0 <- serv.dir %&% "popgen/01_pca/public_mais/"
base.dir <- base.dir0 %&% "04_mais_rsq90/"
work.dir <- base.dir %&% "mais_yri_ibs/"
file.dir <- work.dir %&% "bigsnpr_output/"
plink.dir <- base.dir0 %&% "merged_mcps/"
plink.pre <- "merged_reference_rsq90.merge.mcps.autosomes"
bed.file <- plink.dir %&% plink.pre %&% ".bed"
plink2<-"shared/software/plink2/plink2"
# Read in reference label file (from MCPS only analysis)
lab.file <- "shared/reference_datasets/mais_information/" %&% 
  "reference-population-labels.txt"
exclude.vec <- c("PUR","CLM","PEL","MXL")
lab.df <- fread(lab.file,header=TRUE) %>%
  filter(.,region=="AMERICA") %>%
  filter(.,!(grepl("HGDP",sample))) %>%
  filter(.,!(population %in% exclude.vec))
full.lab.df <- fread(lab.file,header=TRUE)
# Determine related pairs of individuals
rel <- fread(base.dir %&% "bigsnpr_output/bigsnpr_relationships.txt",header=TRUE)

# PCA
# Remove relateds from the bedfile object
(obj.bed <- bed(bed.file))
ind.rel <- match(c(rel$IID1, rel$IID2), obj.bed$fam$sample.ID)
ind.norel <- rows_along(obj.bed)[-ind.rel]
ind.rel.names <- obj.bed$fam$sample.ID[ind.rel]
ind.norel.names <- obj.bed$fam$sample.ID[ind.norel]
mais.samples <- ind.norel.names[ind.norel.names%in%lab.df$sample] # 591 MAIS samples
afr.samples <- filter(full.lab.df,region=="AFRICA",population=="YRI")$sample # 108 AFR samples
eur.samples <- filter(full.lab.df,region=="EUROPE",population=="IBS")$sample # 107 EUR samples

ind.norel.mcps <- ind.norel.names[grepl("MCPS",ind.norel.names)]
ind.norel.mcps500 <- sample(ind.norel.mcps,500,replace=F)

keep.vec <- c(afr.samples,eur.samples,mais.samples,ind.norel.mcps500) ###ind.norel.names ###c(ind.norel.refs,ind.norel.mcps100)
match.vec <- match(keep.vec, obj.bed$fam$sample.ID)
keep.indices <- rows_along(obj.bed)[match.vec]
saveRDS(object=keep.vec,file=file.dir %&% "keep.vec.RDS")
saveRDS(object=keep.indices,file=file.dir %&% "keep.indices.RDS")

# Determine corresponding MAC threshold for MAF 1%
num.chroms <- length(keep.vec) * 2 # This line corresponds to all UNRELATED individuals
mac.threshold <- (0.01 * num.chroms) %>% round(.,0)
saveRDS(object=mac.threshold,file=file.dir %&% "mac.threshold.RDS") # MAC threshold = 50
# Run SVD algorithm
obj.svd <- bed_autoSVD(obj.bed, ind.row = keep.indices, k = 20, min.mac=mac.threshold,
                       ncores = 1)
saveRDS(object=obj.svd,file=file.dir %&% "svd_unrelateds_maf01.rds")
