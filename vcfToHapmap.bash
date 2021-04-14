#!/usr/bin/env bash
#PBS -N tassel
#PBS -l select=1:ncpus=8:mem=75gb:interconnect=1g,walltime=12:00:00
#PBS -o tassel.out
#PBS -e tassel.err


OPTIND=1         # Reset in case getopts has been used previously in the shell.
cd /scratch2/spower2/scripts/v2scripts/Tassel

# Initialize variables:
INPUT="clean.final.renamed.vcf"
OUTPUT="clean.final.renamed.hapmap"

while getopts "h?i:o:" opt; do
    case "${opt}" in
        h|\?)
            printf "\nEx. bash vcfToHapmap.bash -i snps.vcf -o output n\n\
                -i      input VCF file (required)\n\
                -o      output prefix for HapMap file (required)\n\
                ";
            exit 0;
            ;;
        i)  INPUT=${OPTARG}
            ;;
        o)  OUTPUT=${OPTARG}
            ;;
    esac
done
shift $((OPTIND -1))

if [ "${INPUT}" == "" ]
then
    printf "\nbash vcfToHapmap.bash.bash -i snps.vcf -o output.hapmap    -i REQUIRED\n\n"
    exit 1
fi

if [ "${OUTPUT}" == "" ]
then
    printf "\nbash vcfToHapmap.bash.bash -i snps.vcf -o output.hapmap    -o REQUIRED\n\n"
    exit 1
fi

./tassel-5-standalone/run_pipeline.pl -Xmx28G -fork1 \
    -vcf ${INPUT} -export ${OUTPUT} -exportType Hapmap
