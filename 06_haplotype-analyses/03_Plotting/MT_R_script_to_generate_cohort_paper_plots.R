    ###Creating plots for Genetics of MCPS paper###

library(plyr)
library(ggplot2)
library(RColorBrewer)
library(viridis)

Eur_col <- "#238A8DFF"
Mex_C_col <- "#FBFF6F"
Mex_S_col <- "#FB9A99"
Mex_SE_col <- "#B3367AFF"

MT_cohort_plot <- read.csv("./tables and figures/ancestry/population_structure/haplotype-based/MT_MCPS_60K_PC1_20_7way_ancs.txt", sep="")

setwd("./tables and figures/ancestry/population_structure/haplotype-based/pdf_graphs/")

#Fade to black##

pdf("./MT_MCPS_60K_PC1vPC2_MexC.pdf")
ggplot(MT_cohort_plot, aes(x = PC1, y = PC2, colour = Mexico_C)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "#000000", high = Mex_C_col, 
                         name = "Proportion 
Central Mexican 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329 MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

pdf("./MT_MCPS_60K_PC1vPC2_MexS.pdf")
ggplot(MT_cohort_plot, aes(x = PC1, y = PC2, colour = Mexico_S)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "#000000", high = Mex_S_col, 
                        name = "Proportion 
South Mexican 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329 MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

pdf("./MT_MCPS_60K_PC1vPC2_MexSE.pdf")
ggplot(MT_cohort_plot, aes(x = PC1, y = PC2, colour = Mexico_SE)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "#000000", high = Mex_SE_col, 
                        name = "Proportion 
Southeastern Mexican 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329 MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

pdf("./MT_MCPS_60K_PC1vPC2_Eur.pdf")
ggplot(MT_cohort_plot, aes(x = PC1, y = PC2, colour = Europe)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "#000000", high = Eur_col, 
                        name = "Proportion 
European 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329  MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

##fade to gray25##

pdf("./MT_MCPS_60K_PC1vPC2_MexC_grey.pdf")
ggplot(MT_cohort_plot, aes(x = PC1, y = PC2, colour = Mexico_C)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "grey25", high = Mex_C_col, 
                        name = "Proportion 
Central Mexican 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329 MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

pdf("./MT_MCPS_60K_PC1vPC2_MexS_grey.pdf")
ggplot(MT_cohort_plot, aes(x = PC1, y = PC2, colour = Mexico_S)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "grey25", high = Mex_S_col, 
                        name = "Proportion 
South Mexican 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329 MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

pdf("./MT_MCPS_60K_PC1vPC2_MexSE_grey.pdf")
ggplot(MT_cohort_plot, aes(x = PC1, y = PC2, colour = Mexico_SE)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "grey25", high = Mex_SE_col, 
                        name = "Proportion 
Southeastern Mexican 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329 MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

pdf("./MT_MCPS_60K_PC1vPC2_Eur_grey.pdf")
ggplot(MT_cohort_plot, aes(x = PC1, y = PC2, colour = Europe)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "grey25", high = Eur_col, 
                        name = "Proportion 
European 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329  MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

    ###PC3 vs PC4###

#Fade to black##

pdf("./MT_MCPS_60K_PC3vPC4_MexC.pdf")
ggplot(MT_cohort_plot, aes(x = PC3, y = PC4, colour = Mexico_C)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "#000000", high = Mex_C_col, 
                        name = "Proportion 
Central Mexican 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329 MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

pdf("./MT_MCPS_60K_PC3vPC4_MexS.pdf")
ggplot(MT_cohort_plot, aes(x = PC3, y = PC4, colour = Mexico_S)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "#000000", high = Mex_S_col, 
                        name = "Proportion 
South Mexican 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329 MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

pdf("./MT_MCPS_60K_PC3vPC4_MexSE.pdf")
ggplot(MT_cohort_plot, aes(x = PC3, y = PC4, colour = Mexico_SE)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "#000000", high = Mex_SE_col, 
                        name = "Proportion 
Southeastern Mexican 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329 MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

pdf("./MT_MCPS_60K_PC3vPC4_Eur.pdf")
ggplot(MT_cohort_plot, aes(x = PC3, y = PC4, colour = Europe)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "#000000", high = Eur_col, 
                        name = "Proportion 
European 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329  MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

##fade to gray25##

pdf("./MT_MCPS_60K_PC3vPC4_MexC_grey.pdf")
ggplot(MT_cohort_plot, aes(x = PC3, y = PC4, colour = Mexico_C)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "grey25", high = Mex_C_col, 
                        name = "Proportion 
Central Mexican 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329 MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

pdf("./MT_MCPS_60K_PC3vPC4_MexS_grey.pdf")
ggplot(MT_cohort_plot, aes(x = PC3, y = PC4, colour = Mexico_S)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "grey25", high = Mex_S_col, 
                        name = "Proportion 
South Mexican 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329 MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

pdf("./MT_MCPS_60K_PC3vPC4_MexSE_grey.pdf")
ggplot(MT_cohort_plot, aes(x = PC3, y = PC4, colour = Mexico_SE)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "grey25", high = Mex_SE_col, 
                        name = "Proportion 
Southeastern Mexican 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329 MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

pdf("./MT_MCPS_60K_PC3vPC4_Eur_grey.pdf")
ggplot(MT_cohort_plot, aes(x = PC3, y = PC4, colour = Europe)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "grey25", high = Eur_col, 
                        name = "Proportion 
European 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329  MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

    ##As jpegs##

setwd("./tables and figures/ancestry/population_structure/haplotype-based/jpeg_graphs/")

#Fade to black##

jpeg("./MT_MCPS_60K_PC1vPC2_MexC.jpeg")
ggplot(MT_cohort_plot, aes(x = PC1, y = PC2, colour = Mexico_C)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "#000000", high = Mex_C_col, 
                        name = "Proportion 
Central Mexican 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329 MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

jpeg("./MT_MCPS_60K_PC1vPC2_MexS.jpeg")
ggplot(MT_cohort_plot, aes(x = PC1, y = PC2, colour = Mexico_S)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "#000000", high = Mex_S_col, 
                        name = "Proportion 
South Mexican 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329 MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

jpeg("./MT_MCPS_60K_PC1vPC2_MexSE.jpeg")
ggplot(MT_cohort_plot, aes(x = PC1, y = PC2, colour = Mexico_SE)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "#000000", high = Mex_SE_col, 
                        name = "Proportion 
Southeastern Mexican 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329 MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

jpeg("./MT_MCPS_60K_PC1vPC2_Eur.jpeg")
ggplot(MT_cohort_plot, aes(x = PC1, y = PC2, colour = Europe)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "#000000", high = Eur_col, 
                        name = "Proportion 
European 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329  MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

##fade to gray25##

jpeg("./MT_MCPS_60K_PC1vPC2_MexC_grey.jpeg")
ggplot(MT_cohort_plot, aes(x = PC1, y = PC2, colour = Mexico_C)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "grey25", high = Mex_C_col, 
                        name = "Proportion 
Central Mexican 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329 MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

jpeg("./MT_MCPS_60K_PC1vPC2_MexS_grey.jpeg")
ggplot(MT_cohort_plot, aes(x = PC1, y = PC2, colour = Mexico_S)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "grey25", high = Mex_S_col, 
                        name = "Proportion 
South Mexican 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329 MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

jpeg("./MT_MCPS_60K_PC1vPC2_MexSE_grey.jpeg")
ggplot(MT_cohort_plot, aes(x = PC1, y = PC2, colour = Mexico_SE)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "grey25", high = Mex_SE_col, 
                        name = "Proportion 
Southeastern Mexican 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329 MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

jpeg("./MT_MCPS_60K_PC1vPC2_Eur_grey.jpeg")
ggplot(MT_cohort_plot, aes(x = PC1, y = PC2, colour = Europe)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "grey25", high = Eur_col, 
                        name = "Proportion 
European 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329  MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

###PC3 vs PC4###

#Fade to black##

jpeg("./MT_MCPS_60K_PC3vPC4_MexC.jpeg")
ggplot(MT_cohort_plot, aes(x = PC3, y = PC4, colour = Mexico_C)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "#000000", high = Mex_C_col, 
                        name = "Proportion 
Central Mexican 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329 MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

jpeg("./MT_MCPS_60K_PC3vPC4_MexS.jpeg")
ggplot(MT_cohort_plot, aes(x = PC3, y = PC4, colour = Mexico_S)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "#000000", high = Mex_S_col, 
                        name = "Proportion 
South Mexican 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329 MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

jpeg("./MT_MCPS_60K_PC3vPC4_MexSE.jpeg")
ggplot(MT_cohort_plot, aes(x = PC3, y = PC4, colour = Mexico_SE)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "#000000", high = Mex_SE_col, 
                        name = "Proportion 
Southeastern Mexican 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329 MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

jpeg("./MT_MCPS_60K_PC3vPC4_Eur.jpeg")
ggplot(MT_cohort_plot, aes(x = PC3, y = PC4, colour = Europe)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "#000000", high = Eur_col, 
                        name = "Proportion 
European 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329  MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

##fade to gray25##

jpeg("./MT_MCPS_60K_PC3vPC4_MexC_grey.jpeg")
ggplot(MT_cohort_plot, aes(x = PC3, y = PC4, colour = Mexico_C)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "grey25", high = Mex_C_col, 
                        name = "Proportion 
Central Mexican 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329 MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

jpeg("./MT_MCPS_60K_PC3vPC4_MexS_grey.jpeg")
ggplot(MT_cohort_plot, aes(x = PC3, y = PC4, colour = Mexico_S)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "grey25", high = Mex_S_col, 
                        name = "Proportion 
South Mexican 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329 MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

jpeg("./MT_MCPS_60K_PC3vPC4_MexSE_grey.jpeg")
ggplot(MT_cohort_plot, aes(x = PC3, y = PC4, colour = Mexico_SE)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "grey25", high = Mex_SE_col, 
                        name = "Proportion 
Southeastern Mexican 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329 MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()

jpeg("./MT_MCPS_60K_PC3vPC4_Eur_grey.jpeg")
ggplot(MT_cohort_plot, aes(x = PC3, y = PC4, colour = Europe)) +
  geom_point(size = 1.2) +  
  scale_colour_gradient(limits = c(0,1), low = "grey25", high = Eur_col, 
                        name = "Proportion 
European 
Ancestry") +
  #labs(title = "SVD of haplotype copy lengths", subtitle = "58 329  MCPS participants") +
  theme_minimal() +
  theme(plot.background = element_rect(fill = 'grey99'))
dev.off()