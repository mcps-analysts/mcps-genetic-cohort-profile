
"%&%" <- function(a, b) paste0(a, b)
library("data.table")
library("tidyverse")
serv.dir <- "/well/emberson/"
work.dir.serv <- serv.dir %&%
  "popgen/04_rfmix/" %&%
  "including_mais_samples/seven_way/"
input.dir <- work.dir.serv %&% "input_files/"
output.dir <- work.dir.serv %&% "output_files/"
pop.file <- serv.dir%&% "shared/reference_datasets/" %&%
  "mais_information/reference-population-labels.txt"

mais.ref.df <- fread(serv.dir%&% "shared/reference_datasets/" %&%
        "mais_information/mais-population-info_NJtree-regions.txt")

rgnkey.dir <- serv.dir %&%
  "projects/freeze_145k/03_rgc-qc-steps/input_files/"
rgnkey.file = rgnkey.dir %&% "freeze_145k_id-key.csv"
rgn.link.df <- fread(rgnkey.file)[, c(1, 3)]
names(rgn.link.df) <- c("MCPS.ID", "IID")
rgn.link.df$IID <-  as.character(rgn.link.df$IID)

rfmix.q.df <- fread(work.dir.serv %&% "output_files/"%&%
                      "global-ancestry-estimates.txt")
join.df <- inner_join(rfmix.q.df, rgn.link.df, by="IID")
mcps.sub.df <- filter(rfmix.q.df, IID %in% join.df$IID)
mcps.sub.df <- inner_join(mcps.sub.df, rgn.link.df, by="IID")
mcps.sub.df <- dplyr::select(mcps.sub.df, one_of("MCPS.ID", "AFRICA", "EUROPE", 
    "MEXICO_C", "MEXICO_N", "MEXICO_NW", "MEXICO_S", "MEXICO_SE"))
names(mcps.sub.df)[1] <- "IID"
ref.sub.df <- filter(rfmix.q.df, !(IID %in% join.df$IID))
rfmix.q.df <- rbind(mcps.sub.df, ref.sub.df)

ref.sub.df <- filter(rfmix.q.df, !(grepl("MCPS", IID)))
mcps.sub.df <- filter(rfmix.q.df, (grepl("MCPS", IID)))
ref.id.vec <- purrr::map(ref.sub.df$IID, function(s){
  li <- strsplit(s, split="-")[[1]]
  paste0(li[2:length(li)], collapse="-")
}) %>% as.character(.)
ref.sub.df$IID <- ref.id.vec
mcps.sub.df <- mcps.sub.df#[c(1:1000), ]## Full Set
rfmix.q.df <- rbind(mcps.sub.df, ref.sub.df)

write_rds(x=rfmix.q.df, path=work.dir.serv%&%"output_files/rfmix.q.df.RDS")

pop.df <- fread(pop.file)
ref.df <- c()
pb <- txtProgressBar(min=0, max=dim(rfmix.q.df)[1], style=3)
for (i in 1:dim(rfmix.q.df)[1]){
  setTxtProgressBar(pb, i)
  samp <- rfmix.q.df$IID[i]
  sub.df <- filter(pop.df, sample==samp)
  if (dim(sub.df)[1]==0){
    sub.df <- data.table("sample"=samp, "population"="MCPS", 
                         "region"="AMERICA", stringsAsFactors=F)
  }
  ref.df <- rbind(ref.df, sub.df)
}
names(ref.df)[1] <- "IID"

write_rds(x=ref.df, path=work.dir.serv%&%"output_files/ref.df.RDS")

library("viridis")
reformat_df <- function(df, k=3){
  out.df <- c()
  pb <- txtProgressBar(min=0, max=dim(df)[1], style=3)
  for (i in 1:dim(df)[1]){
    setTxtProgressBar(pb, i)
    row.df <- df[i, ]
    prop.vec <- row.df[, (dim(row.df)[2]-k+1):dim(row.df)[2]] %>% as.numeric(.)
    grp.names <- row.df[, (dim(row.df)[2]-k+1):dim(row.df)[2]] %>% names(.)
    build.df <- data.frame("IID"=row.df$IID, 
                           "Proportion"=prop.vec, "Ancestry"=grp.names, 
                           stringsAsFactors = F)
    out.df <- rbind(out.df, build.df)
  }
  return(out.df)
}

pop_plot <- function(sub.df, col.vec, hide.text=TRUE, hide.legend=FALSE){
  plt <- ggplot(data=sub.df, aes(x=IID, y=Proportion)) +
    geom_bar(stat="identity", 
             aes(fill=Ancestry, col=Ancestry)) +
  scale_y_continuous(breaks=seq(0, 1, 0.1)) +
  scale_fill_manual(values=col.vec) +
  scale_color_manual(values=col.vec) +
    facet_wrap(~population, scales="free_x", 
               strip.position="bottom", 
               nrow=1) +
    theme(axis.text.x=element_blank(), 
          axis.title.x = element_blank(), 
          axis.ticks.x=element_blank(), 
          panel.background = element_blank(), 
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), 
          strip.placement = "outside", 
          strip.background = element_rect(fill="white"), 
          strip.text = element_text(size=6))
  if (hide.text==TRUE){
    plt <- plt + theme(axis.text=element_blank(), 
                       axis.title=element_blank(), 
                       axis.ticks=element_blank())
  }
  if (hide.legend==TRUE){
    plt <- plt + theme(legend.position ="none")
  }
  return(plt)
}

region_plot <- function(sub.df, col.vec, hide.legend=FALSE){
  plt <- ggplot(data=sub.df, aes(x=IID, y=Proportion)) +
    geom_bar(stat="identity", 
             aes(fill=Ancestry, col=Ancestry)) +
  scale_y_continuous(breaks=seq(0, 1, 0.1)) +
  scale_fill_manual(values=col.vec) +
  scale_color_manual(values=col.vec) +
    facet_wrap(~region, scales="free_x", 
               strip.position="bottom", 
               nrow=1) +
    theme(axis.text.x=element_blank(), 
          axis.title.x = element_blank(), 
          axis.ticks.x=element_blank(), 
          panel.background = element_blank(), 
          panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), 
          strip.placement = "outside", 
          strip.background = element_rect(fill="white"), 
          strip.text = element_text(size=6))
  if (hide.legend==TRUE){
    plt <- plt + theme(legend.position ="none")
  }
  return(plt)
}

rfmixQ.plt.df <- reformat_df(rfmix.q.df, k=7)

write_rds(x=rfmixQ.plt.df, path=work.dir.serv%&%
            "output_files/rfmixQ.plt.df.RDS")

lev.vec <- (filter(rfmixQ.plt.df, Ancestry=="EUROPE") %>%
  arrange(desc(Proportion)))$IID %>% unique(.)
plt.df$IID <- factor(plt.df$IID, levels=lev.vec)

plt.df$Ancestry <- factor(plt.df$Ancestry, 
  levels=c("AFRICA", "EUROPE", 
           "MEXICO_C", "MEXICO_S", "MEXICO_SE", "MEXICO_NW", "MEXICO_N"))

library("cowplot")
vir.vec <- viridis(20)
cvec <- c("#FDE725FF", "#2D718EFF", "#FDBF6F", 
          "#FB9A99", "#B3367AFF", "#FF7F00", "#E31A1C")
plt1a <- region_plot(filter(plt.df, population!="MCPS"), 
                     col.vec=cvec, hide.legend=T)

plt1b <- pop_plot(filter(plt.df, population=="MCPS"), col.vec=cvec, hide.text=F, 
                  hide.legend = F)

plt1.full <- cowplot::plot_grid(plt1a, plt1b, nrow=1, rel_widths = c(1, 5))
plt1.mcps <- cowplot::plot_grid(plt1b, nrow=1)

#AMR-MAIS-North  "#E31A1C"
#AMR-MAIS-Northwest  "#FF7F00"
#AMR-MAIS-Central  "#FDBF6F"
#AMR-MAIS-South  "#FB9A99"
#AMR-MAIS-Southeast  "#B3367AFF"

local.dir <- "popgen/04_rfmix/including_mais_samples/seven_way/"
ggsave(plot=plt1.mcps, filename=work.dir.serv%&%
         "plots/rfmix.admixture-plot-freeze150k.png", 
       height=2.5, width =12, type = "cairo")
ggsave(plot=plt1.full, filename=work.dir.serv%&%
         "plots/rfmix.admixture-plot-freeze150k-with-references.png", 
       height=2.5, width =15, type = "cairo")

