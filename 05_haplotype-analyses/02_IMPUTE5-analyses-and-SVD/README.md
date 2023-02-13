The scripts in this folder take the QCed MCPS data and perform the following steps:

1. Create .imp input files for IMPUTE5.
2. Run IMPUTE5 to produce matrices of the length of the genome for which each haplotype 
is most similar to each other haplotype.
3. Unzip and condense the matrices to correspond to individuals.
4. Combine the matrices for (portions of) chromosomes into one four tranches.
5. Combine the four tranches in to one describing the whole genome.
6. Perform SVD.
