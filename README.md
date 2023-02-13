# mcps-genetic-cohort-profile

This repository hosts code scripts used for performing population structure and ancestry analyses described in [Ziyatdinov, Torres and Alegre-Díaz et al. 2022](https://doi.org/10.1101/2022.06.26.495014). 

## Overview of repository directories 
-----------------------------------------------------------------------------
- **01_pca**: Scripts used for performing principal components analysis (PCA) using workflow described in [Privé et al. 2020](https://doi.org/10.1093/bioinformatics/btaa520). 
- **02.1_terastructure**: Scripts used for performing population structure analysis using the software [TeraStructure](https://github.com/StoreyLab/terastructure). 
- **02.2_admixture**: Scripts used for performing population structure analysis using the software [ADMIXTURE](https://dalexander.github.io/admixture/). 
- **03_phasing**: Scripts used for phasing reference genotypes used in local ancestry analyses described in **04_rfmix** directory. Phasing was performed with [SHAPEIT v4](https://odelaneau.github.io/shapeit4/) software. 
- **04_rfmix**: Scripts used to perform local ancestry inference (LAI) analyses with the software [RFMix](https://sites.google.com/site/rfmixlocalancestryinference/). 
- **05_haplotype-analyses**: Scripts used to perform population structure analysis using haplotype sharing measures estimated with the software [IMPUTE5](https://jmarchini.org/software/#impute-5). 


 ## Descripton of directory structure and analyses 
 ---------------------------------------------------------------------------
 ### 01_pca 
 Sub-directories within 01_pca directory corresponded to separate analyses: 
 - **public**: Reference genotypes correspond to publicly-available samples from the [1000 Genomes Project (1KG)](http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data_collections/1000G_2504_high_coverage/working/20201028_3202_phased/) and [Human Genome Diversity Panel (HGDP)](https://doi.org/10.1126/science.aay5012) that have been whole-genome sequenced. The PCA model was based on 1KG, HGDP and 500 unrelated MCPS samples. Remaining MCPS samples were projected into the PC space defined by the model. 
  - **public_mais**: Reference genotypes correspond to publicly-available samples from 1KG and HGDP studies, and participants of Indigenous American ancestry from Mexico within the [Metabolic Analysis of an Indigenous Samples (MAIS) study](https://www.nature.com/articles/s41467-021-26188-w). The PCA model was based on 1KG, HGDP, MAIS and 500 unrelated MCPS samples. Remaining MCPS samples were projected into the PC space defined by the model. Note: the **mais_yri_ibs** sub-directory contains scripts for analysis were reference samples were limited to Indigenous American samples from Mexico (MAIS study), Iberian Europeans from Spain (IBS) and Yoruba from Nigeria (YRI).  
  - **mcps_only**: Reference genotypes correspond to 58,051 unrelated MCPS particpants. All remaining MCPS participants, and samples from the 1KG, HGDP and MAIS studies were projected into the PC space defined by the model. Sub-directories within **mcps_only** correspond to analyses conducted with clumping LD r2 thresholds of 0.20, 0.01, and 0.005, respectively.    
  
 ### 02.1_terastructure
 
 ### 02.2_admixture
 
 ### 03_phasing
 
 ### 04_rfmix
 
 ### 05_haplotype-analyses
 
 
