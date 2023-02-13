##module load R/3.6.2-foss-2019b
"%&%" <- function(a,b) paste0(a,b)
library("data.table");library("dplyr")
base.dir <- "./popgen/"
work.dir <- base.dir %&% "02.1_terastructure/mais_analyses/" %&%
  "afr_eas_eur_mais_amr-select_mcps1k/"
ref.file <- "./shared/reference_datasets/mais_information/" %&%
  "reference-population-labels.txt"
mais.ref.df <- fread("./shared/reference_datasets/" %&%
        "mais_information/mais-population-info_NJtree-regions.txt")
mcps.fam.file <- "./popgen/01_pca/" %&%
  "./public_mais/mcps/geno_files/mcps.autosomes.fam"
mcps10k.id.file <- "./sharing/" %&%
  "MT_MCPS10K_SVD_of_co-anc_matrix_FIDIID_PC1_PC2_cont_scores.txt"

# Reference samples
df <- fread(ref.file,header=TRUE)
keep.vec <- c("AMERICA","EUROPE","AFRICA","EAST_ASIA") # Excluding South Asian, Middle Eastern, Oceanic
sub.df <- filter(df,sample%in%filter(df,region%in%keep.vec)$sample)
mais.df <- filter(sub.df,!grepl("HG",sample)) %>% filter(.,!grepl("NA",sample))
mais.build.df <- data.frame("V1"="0","V2"=mais.df$sample)
# Will keep AFR, EAS, MXL, and European samples, Pima and Maya as well from HGDP
sub.df2 <- filter(sub.df,population%in%c("MXL","Pima","Maya")|
region=="EUROPE"|region=="AFRICA"|region=="EAST_ASIA")


public.df <- filter(sub.df2,!(sample%in%mais.df$sample))
public.build.df <- data.frame("V1"=public.df$sample,"V2"=public.df$sample)
write.df <- rbind(public.build.df,mais.build.df)
# Unrelated MCPS 10k subset
mcps.fam.df <- fread(mcps.fam.file,header=F)
mcps10k.df <- fread(mcps10k.id.file,header=T)
# Randomly sample 1K individuals
set.seed(1)
mcps.keep.vec <- mcps10k.df$IID[sample(1:length(mcps10k.df$IID),1000,replace=F)]
mcps.keep.df <- filter(mcps.fam.df,V2%in%mcps.keep.vec) %>%
  dplyr::select(one_of("V1","V2"))
write.df <- rbind(write.df,mcps.keep.df)

write.table(x=write.df,file=work.dir%&%"input_files/subset-samples.txt",
            sep="\t",row.names=F,col.names=F,quote=F)
