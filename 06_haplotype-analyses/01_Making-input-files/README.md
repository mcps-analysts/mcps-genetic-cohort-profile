This folder contains scripts to create appropriately-formatted vcf files for use with IMPTUE5.
It procedes in four stages.

1. The 00. scripts create a series of formatted ID files for use with the .bed and .vcf files.
2. The 01 script selected the set of 60K unrelated MCPS participantsm checks that they are unrelated
and writes out files with MAF >1%.
3. The 02 script creates a list of ambiguous variants from the output of stage 2.
4. The 03 script takes phased vcf files, and selects only the 60K unrelated participants and removes 
ambiguous variants and those with MAF <1% before saving them as compressed phased vcf files.
