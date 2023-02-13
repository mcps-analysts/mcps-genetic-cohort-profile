
"%&%" <- function(a,b) paste0(a,b)
library("data.table")
library("tidyverse")
library("bigsnpr")

serv.dir <- "./"
work.dir0 <- serv.dir %&% "popgen/01_pca/public_mais/04_mais_rsq90/"
work.dir <- serv.dir %&% "popgen/01_pca/mcps_only/" %&%
  "reference_projections/ld_rsq005/"
base.dir <- serv.dir %&% "popgen/01_pca/public_mais/"
file.dir <- work.dir %&% "bigsnpr_output/"
plink.dir <- base.dir %&% "merged_mcps/"
plink.pre <- "merged_reference_rsq90.merge.mcps.autosomes"
bed.file <- plink.dir %&% plink.pre %&% ".bed"


obj.svd2 <- readRDS(file.dir %&% "svd_unrelateds_maf01-mcps-only.rds")
S <- readRDS(file.dir %&% "knn-dist-stats_unrelateds_maf01-mcps-only.rds")

rel <- fread(work.dir0 %&% "bigsnpr_output/bigsnpr_relationships.txt")
obj.bed <- bed(bed.file)
keep.indices <- readRDS(file.dir %&% "keep.indices.RDS")
ind.row <- keep.indices#[S < 1.0] # No outlier thresholding is necessary here
subject.vec <- obj.bed$fam$sample.ID[keep.indices]

# Verification

scree.plt <- plot(obj.svd2)
loadings.plt <- plot(obj.svd2, type = "loadings", loadings = 1:20, coeff = 0.4)
scores.plt <- plot(obj.svd2, type = "scores", scores = 1:20, coeff = 0.4)

ggsave(plot=scree.plt,filename=file.dir %&%
         "plots/svd2_unrelateds_maf01-mcps-only_scree.png",
       width=5,height=3.5)
ggsave(plot=loadings.plt,filename=file.dir %&%
         "plots/svd2_unrelateds_maf01-mcps-only_loadings.png",
       width=20,height=10)
ggsave(plot=scores.plt,filename=file.dir %&%
         "plots/svd2_unrelateds_maf01-mcps-only_pc-scores.png",
       width=10,height=10)

PCs <- matrix(NA, nrow(obj.bed), ncol(obj.svd2$u))
PCs[ind.row, ] <- predict(obj.svd2)

proj <- bed_projectSelfPCA(obj.svd2, obj.bed,
                           ind.row = rows_along(obj.bed)[-ind.row])#,
                           #ncores = nb_cores())
PCs[-ind.row, ] <- proj$OADP_proj
saveRDS(proj,file=file.dir%&%"projections_unrelateds_maf01-mcps-only.RDS")
saveRDS(PCs,file=file.dir%&%"projections-matrix_unrelateds_maf01-mcps-only.RDS")


out.df <- as.data.frame(PCs)
names(out.df) <- "PC" %&% 1:20
out.df$sample.ID <- obj.bed$fam$sample.ID

out.df <- dplyr::select(out.df,one_of(c("sample.ID","PC"%&%1:20)))
write.table(x=out.df,file=file.dir %&% "pc_projections_unrelateds_maf01-mcps-only.txt",
            sep="\t",quote=F,row.names=F)
