#module load R/3.6.2-foss-2019b
"%&%" <- function(a, b) paste0(a, b)
library("dplyr")
library("data.table")
args = commandArgs(trailingOnly = TRUE)
filedir <- args[1]
bimfile <- args[2]
setnum <- args[3]
df <- fread(filedir %&% imfile, header = F)
id.vec <- df$V2
dups <- id.vec[(duplicated(id.vec))]
write.table(x = dups, file = filedir %&% "duplicated-set" %&% setnum %&% ".txt", 
            sep = "\t", quote = F, row.names = F, col.names = F)


