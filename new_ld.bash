#!/usr/bin/env bash
#PBS -N snpLD
#PBS -l select=1:ncpus=8:mem=50gb:interconnect=1g,walltime=1:00:00
#PBS -o snps.out
#PBS -e snps.err

# Directions for creating .ped and .map plink files.
#sed 's/chr1LG6/1/g' cohort_final.vcf > final.renamed.vcf


# if 10 SNPs, second number should be 10 that is 1..10
for i in {1..3}
do
    SNP_NAME=$(head -n ${i} mysnps.txt | tail -n 1)
    ./plink --file Pisum.plink \
        --r2 --ld-snp ${SNP_NAME} --ld-window-kb 1000 --ld-window 99999 --ld-window-r2 0
    mv plink.ld ${SNP_NAME}.plink.ld
done
~    
