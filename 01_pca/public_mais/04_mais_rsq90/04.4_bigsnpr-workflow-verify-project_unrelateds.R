"%&%" <- function(a,b) paste0(a,b)
library("data.table")
library("tidyverse")
library("bigsnpr")

serv.dir <- "/well/emberson/users/bjk420/"
serv.dir<-"/Users/jasont/science/servers/FUSE1/users/bjk420/"
base.dir <- serv.dir %&% "projects/popgen/01_pca/global_inmegen/imputed-topmed/"
work.dir <- base.dir %&% "04_mais_rsq90/"
file.dir <- work.dir %&% "bigsnpr_output/"
plink.dir <- base.dir %&% "merged_mcps/"
plink.pre <- "merged_reference_rsq90.merge.mcps.autosomes"
bed.file <- plink.dir %&% plink.pre %&% ".bed"

#obj.svd2 <- readRDS(file.dir %&% "svd2_unrelateds_maf01.rds") # Note that 03.3.1 did not have to be run as no outliers were detected in 03.2.1
obj.svd2 <- readRDS(file.dir %&% "svd_unrelateds_maf01.rds") # deliberately using this file here per above comment
S <- readRDS(file.dir %&% "knn-dist-stats_unrelateds_maf01.rds")

rel <- fread(file.dir %&% "bigsnpr_relationships.txt")
obj.bed <- bed(bed.file)
keep.indices <- readRDS(file.dir %&% "keep.indices.RDS")
ind.row <- keep.indices#[S < 1.0] # No outlier thresholding is necessary here

subject.vec <- obj.bed$fam$sample.ID[keep.indices]

scree.plt <- plot(obj.svd2)
loadings.plt <- plot(obj.svd2, type = "loadings", loadings = 1:20, coeff = 0.4)
scores.plt <- plot(obj.svd2, type = "scores", scores = 1:20, coeff = 0.4)

## Need to run locally to save plots!
ggsave(plot=scree.plt,filename=file.dir %&%
         "plots/svd2_unrelateds_maf01_scree.png",
       width=5,height=3.5)
ggsave(plot=loadings.plt,filename=file.dir %&%
         "plots/svd2_unrelateds_maf01_loadings.png",
       width=20,height=10)
ggsave(plot=scores.plt,filename=file.dir %&%
         "plots/svd2_unrelateds_maf01_pc-scores.png",
       width=10,height=10)

PCs <- matrix(NA, nrow(obj.bed), ncol(obj.svd2$u))
PCs[ind.row, ] <- predict(obj.svd2)

proj <- bed_projectSelfPCA(obj.svd2, obj.bed,
                           ind.row = rows_along(obj.bed)[-ind.row])
#                           ncores = nb_cores())
PCs[-ind.row, ] <- proj$OADP_proj
saveRDS(proj,file=file.dir%&%"projections_unrelateds_maf01.RDS")
saveRDS(PCs,file=file.dir%&%"projections-matrix_unrelateds_maf01.RDS")

#plot(PCs[ind.row, 7:8], pch = 20, xlab = "PC7", ylab = "PC8")
#points(PCs[-ind.row, 7:8], pch = 20, col = "blue")

out.df <- as.data.frame(PCs)
names(out.df) <- "PC" %&% 1:20
out.df$sample.ID <- obj.bed$fam$sample.ID

out.df <- dplyr::select(out.df,one_of(c("sample.ID","PC"%&%1:20)))
write.table(x=out.df,file=file.dir %&% "pc_projections_unrelateds_maf01.txt",
            sep="\t",quote=F,row.names=F)
