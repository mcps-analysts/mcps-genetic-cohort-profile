This folder contains scripts to create appropriately-formatted vcf files for use with IMPTUE5.
It procedes in four stages.

1. The 01 scripts create a series of formatted ID files for use with the .bed and .vcf files. 
   00.1 Selects the FID and IID of each partitipant in the set of 60K unrelated individuals.
        This is used in the 02 script.
   00.2 Selects the vcf IDs of those individuals for use in the 04 files.
   00.3 Creates a key between vcf IDs and the numeric key used in some of the genetics files. 
        This is used when marrying up participants with their ancestry proportions for plotting.

2. The 02 script selected the set of 60K unrelated MCPS participants checks that they are unrelated
and writes out files with MAF >1%.

3. The 03 script creates a list of ambiguous variants from the output of stage 2.

4. The 04 script takes phased vcf files, and selects only the 60K unrelated participants and 
removes ambiguous variants and those with MAF <1% before saving them as compressed phased vcf files.
