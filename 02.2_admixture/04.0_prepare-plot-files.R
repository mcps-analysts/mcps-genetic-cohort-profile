# module load R/3.6.2-foss-2019b
"%&%" <- function(a,b) paste0(a,b)
library("data.table")
library("tidyverse")

serv.dir <- ""
base.dir <- serv.dir %&% "popgen/"
work.dir <- serv.dir %&%
  "popgen/02.2_admixture/afr_eas_eur_mais_amr-select-mcps1k/"
pop.file <- serv.dir%&% "shared/reference_datasets/" %&%
  "mais_information/reference-population-labels.txt"

mais.ref.df <- fread(serv.dir%&% "shared/reference_datasets/" %&%
        "mais_information/mais-population-info_NJtree-regions.txt")

samp.ref.df <- fread(work.dir %&% "input_files/ref.fam",
                 header=F)
samp.study.df <- fread(work.dir %&% "input_files/mcps150k.fam",
                 header=F)
samp.df <- rbind(samp.ref.df,samp.study.df)
pop.df <- fread(pop.file)
ref.df <- c()
pb <- txtProgressBar(min=0,max=dim(samp.df)[1],style=3)
for (i in 1:dim(samp.df)[1]){
  setTxtProgressBar(pb,i)
  samp <- samp.df$V2[i]
  sub.df <- filter(pop.df,sample==samp)
  if (dim(sub.df)[1]==0){
    sub.df <- data.table("sample"=samp,"population"="MCPS",
                         "region"="AMERICA",stringsAsFactors=F)
  }
  ref.df <- rbind(ref.df,sub.df)
}
saveRDS(object=ref.df,file=work.dir%&%"output_files/"%&%
          "ref.df.RDS")

mcps.ref.df <- fread(serv.dir%&%"projects/mcps/data/phenotypes/" %&%
        "BASELINE.csv",header=T) %>%
  dplyr::select(.,one_of("REGISTRO","COYOACAN","IZTAPALAPA"))
mcps.ref.df$district <- purrr::map(mcps.ref.df$COYOACAN,function(s){
  ifelse(s==1,"Coyoacan","Iztapalapa")
}) %>% as.character(.) # about a 4:6 ratio for plotting
rgn.link.df <- fread(serv.dir%&%"projects/mcps/data/phenotypes/" %&%
                       "RGN_LINK.csv",header=T)
mcps.ref.df <- dplyr::inner_join(mcps.ref.df,rgn.link.df,
                                 by="REGISTRO")
mcps.sub.df <- filter(ref.df,population=="MCPS")
pb <- txtProgressBar(min=0,max=dim(mcps.sub.df)[1],style=3)
mcps.sub.df$district <- purrr::map(1:dim(mcps.sub.df)[1],function(i){
  setTxtProgressBar(pb,i)
  s <- (mcps.sub.df$sample[i] %>% strsplit(.,split="_"))[[1]][2]
  filter(mcps.ref.df,PATID==s)$district
}) %>% as.character(.)
rm(mcps.ref.df)
saveRDS(object=mcps.sub.df,file=work.dir%&%"output_files/"%&%
          "mcps.sub.df.RDS")

get_top_groups <- function(mean.df,thresh=0.95){
  sort.df <- mean.df %>% sort(.,decreasing = TRUE)
  grp.names <- names(sort.df)
  grp.vec <- as.numeric(sort.df)
  cumsum = 0
  keep.vec <- c()
  for (i in 1:length(grp.vec)){
    val <- grp.vec[i]
    if (cumsum<=thresh){
      keep.vec <- append(keep.vec,grp.names[i])
      cumsum <- cumsum + val
    }
  }
  return(list(keep.vec,cumsum))
}

create_plot_df <- function(k){
  theta.ref.file <- work.dir%&%"output_files/ref."%&%k%&%".Q"
  theta.study.file <- work.dir%&%"output_files/mcps150k."%&%k%&%".Q"
  theta.ref.df <- fread(theta.ref.file,header=F)[,1:k]
  theta.study.df <- fread(theta.study.file,header=F)[,1:k]
  theta.df <- rbind(theta.ref.df,theta.study.df)
  names(theta.df) <- "G" %&% 1:k # "G" short for "Group"
  theta.df <- cbind(ref.df,theta.df)
  plot.df <- c()
  pb <- txtProgressBar(min=0,max=dim(theta.df)[1],style=3)
  for (i in 1:dim(theta.df)[1]){
    setTxtProgressBar(pb,i)
    row.df <- theta.df[i,]
    prop.vec <- row.df[,(dim(row.df)[2]-k+1):dim(row.df)[2]] %>%
      as.numeric(.)
    grp.names <- row.df[,(dim(row.df)[2]-k+1):dim(row.df)[2]] %>%
      names(.)
    build.df <- data.frame("IID"=row.df$sample,
                           "Population"=row.df$population,
                           "Region"=row.df$region,
                           "Proportion"=prop.vec,"K"=grp.names,
                           stringsAsFactors = F)
    plot.df <- rbind(plot.df,build.df)
  }
  return(plot.df)
}

print("Saving plot data file for K=4")
k4.df <- create_plot_df(4)
saveRDS(object=k4.df,file=work.dir%&%"output_files/k4.df.RDS")

print("Saving plot data file for K=18")
k18.df <- create_plot_df(18)
saveRDS(object=k18.df,file=work.dir%&%"output_files/k18.df.RDS")
