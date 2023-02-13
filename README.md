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
Sub-directories within 02.1_terastructure directory corresponded to separate analyses: 
- **mais_amr_afr_eur_eas**: Reference samples included individuals of African (AFR), East Asian (EAS), European (EUR), and American (AMR) ancestry from the 1KG and HGDP studies, and AMR samples from Mexico from the MAIS study. 
- **afr_eas_eur_mais_amr-select_mcps1k**: Reference samples included individuals of African (AFR), East Asian (EAS), European (EUR), and American (AMR) ancestry from the 1KG and HGDP studies, and AMR samples from Mexico from the MAIS study. A random set of 1,000 unrelated MCPS participants were also included as reference samples in the analysis. 
- **mais_amr_afr_eur_mcps10k**: Reference samples included individuals of African (AFR), East Asian (EAS), European (EUR), and American (AMR) ancestry from the 1KG and HGDP studies, and AMR samples from Mexico from the MAIS study. A random set of 10,000 unrelated MCPS participants were also included as reference samples in the analysis. 

### 02.2_admixture
Scripts within this directory correspond to analysis with reference samples of AFR, EAS, EUR, and AMR ancestry from the 1KG and HGDP studies, AMR samples from Mexico (MAIS study), and a random set 1,000 unrelated MCPS participants. The remaining set of MCPS participants were projected using the estimated model parameters (i.e. ancestry-specific allele frequencies) in order to estimate ancestry proportion values. Projection was performed using model with four underlying ancestries (i.e. K=4) and the model that attained the lowest cross-validation error (i.e. K=18). 

### 03_phasing
The script in this folder contains arguments used to phase genotypes of non-MCPS samples, from which reference samples were selected for LAI analyses described in **04_rfmix** folder. 
 
 ### 04_rfmix
 The sub-directories in this folder correspond to two sets of analyses:
 - **public_references_only**: This folder contains scripts for running a three-way admixture model with RFMix to resolve local ancestry segments within reference samples and MCPS participants. Reference samples included publicly-available genotypes from samples of EUR, AFR, and AMR ancestries within the 1KG and HGDP studies. 
    - **Note**: The **00_chromosomeX** sub-directory includes scripts used for merging chromosome X genotypes across datasets.  
 - **including_mais_samples**: This folder contains scripts for running RFMix to resolve local ancestry segments within reference samples and MCPS participants. Reference samples included publicly-available genotypes from samples of EUR, AFR, and AMR ancestries within the 1KG and HGDP studies, and participants of Indigenous American ancestry from Mexico from the MAIS study. 
    - **three_way**: This folder contains scripts for running a three-way admixture model that includes EUR, AFR, and AMR ancestries. 
    - **seven_way**: This folder contains scripts for running a seven-way admixture model that includes EUR, AFR, and AMR ancestries. The AMR reference samples corresponded to the MAIS study and were grouped into five 'regions' within Mexico (North, Nortwest, Central, South, Southeast) previously delineated in [García-Ortiz et al. *Nat. Commun.* 2021](https://www.nature.com/articles/s41467-021-26188-w).
    - **Note**: The **00_chromosomeX** sub-directory includes scripts used for merging chromosome X genotypes across datasets. 
 
### 05_haplotype-analyses
- **01_Making-input-files**: This folder contains scripts used to create appropriately-formatted vcf files as input for IMPUTE5. Only non-ambiguous variants with minor allele frequency >1% and participants in the same 58K used in the **mcps_only** analyses from the **01_pca** folder were selected.
- **02_IMPUTE5-analyses-and-SVD**: This folder contains scripts used to run IMPUTE 5 on all the autosomes with chromosomes 1-15 split at the centromere to make the analysis more computationally tractable. Per-haplotype matrices were then condensed into per-individual matrices. These matrices for each chromosome are then summed to create one matrix for the whole genome. Finally, SVD was run on the matrix.
- **03_Plotting**: This folder contains the script used to create the plots in supplementary figure 13. It takes the SVD output and the output from the seven-way RFMix analyses within folder **04_rfmix**.
 
 
