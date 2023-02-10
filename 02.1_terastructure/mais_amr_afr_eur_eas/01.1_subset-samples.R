## module load R/3.6.2-foss-2019b
"%&%" <- function(a, b) paste0(a, b)
library("data.table");library("dplyr")
base.dir <- "popgen/"
work.dir <- base.dir %&% "02.1_terastructure/mais_amr_afr_eur_eas/"
ref.file <- "shared/reference_datasets/mais_information/" %&%
  "reference-population-labels.txt"

# Reference samples
df <- fread(ref.file, header=TRUE)
keep.vec <- c("AMERICA", "EUROPE", "AFRICA", "EAST_ASIA") 
sub.df <- filter(df, sample %in% filter(df, region %in% keep.vec)$sample)
mais.df <- filter(sub.df, !grepl("HG", sample)) %>% filter(., !grepl("NA", sample))
mais.build.df <- data.frame("V1"="0", "V2"=mais.df$sample)
public.df <- filter(sub.df, !(sample %in% mais.df$sample))
public.build.df <- data.frame("V1"=public.df$sample, "V2"=public.df$sample)
write.df <- rbind(public.build.df, mais.build.df)

write.table(x=write.df, file=work.dir %&% "input_files/subset-samples.txt", 
            sep="\t", row.names=F, col.names=F, quote=F)
