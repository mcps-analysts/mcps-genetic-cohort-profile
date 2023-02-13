#module load R/4.1.0-foss-2021a

#loading key packages
library(bigstatsr)
library(bigmemory)
library(data.table)
#library(ggplot2)
#library(viridis)

MCPS_60K_coanc <- fread("./pop_structure/data/IMPUTE5_Output/60K_analyses/Final/MT_final_60K_co-anc_matrix.txt", header = FALSE)

message1 <- "Matrix loaded"
message1

MCPS_60K_FBM <- as_FBM(MCPS_60K_coanc)
MCPS_60K_tFBM <- big_transpose(MCPS_60K_FBM)

message1.5 <- "Matrix transposed"
message1.5

set.seed(4010)

obj.60K_SVD <- big_randomSVD(MCPS_60K_tFBM, fun.scaling = big_scale(center = TRUE, scale = TRUE), k = 20)

message2 <- "SVD done"
message2

setwd("./pop_structure/data/IMPUTE5_Output/60K_analyses/SVD_results")

Singular_values_60K <- obj.60K_SVD$d
write.table(Singular_values_60K, "./PC_table/MT_138K_60K_singular_vals.txt", row.names = FALSE, col.names = FALSE, quote = FALSE) 

scores_MCPS_60K <- predict(obj.60K_SVD)

df.scores_MCPS_60K <- as.data.frame(scores_MCPS_60K)

colnames(df.scores_MCPS_60K) <- c("PC1", "PC2", "PC3", "PC4", "PC5", "PC6", "PC7", "PC8", "PC9", "PC10", "PC11", "PC12", "PC13", "PC14", "PC15", "PC16", "PC17", "PC18", "PC19", "PC20") #, "PC21", "PC22", "PC23", "PC24", "PC25", "PC26", "PC27", "PC28", "PC29", "PC30", "PC31", "PC32", "PC33", "PC34", "PC35", "PC36", "PC37", "PC38", "PC39", "PC40")

write.table(df.scores_MCPS_60K, "./PC_table/MCPS_138K_60K_PCs1-20.txt", quote = FALSE, row.names = FALSE)
