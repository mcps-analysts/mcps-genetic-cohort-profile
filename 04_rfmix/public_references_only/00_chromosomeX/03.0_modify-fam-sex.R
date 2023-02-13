# module load R/3.6.2-foss-2019b
"%&%" <- function(a, b) paste0(a, b)
library("data.table"); library("tidyverse")
work.dir <- "./"
out.dir <- work.dir %&% "merged_mcps/"

file1 <- out.dir %&%
    "merged_hgdp-1kg_chrX.merge.MCPS_Freeze_150.GT_hg38.pVCF" %&% ".fam_ORIG"
df1 <- fread(file1, header=F)
df1$V5 <- -9
write.table(x=df1, file=out.dir %&%
  "merged_hgdp-1kg_chrX.merge.MCPS_Freeze_150.GT_hg38.pVCF" %&% ".fam", sep="\t", 
  quote=FALSE, row.names=F, col.names=F)

