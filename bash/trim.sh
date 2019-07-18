#!/bin/bash
#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --time=8:00:00
#SBATCH --mem=16GB
#SBATCH -o /data/biohub/20190129_Lardelli_FMR1_RNASeq/slurm/%x_%j.out
#SBATCH -e /data/biohub/20190129_Lardelli_FMR1_RNASeq/slurm/%x_%j.err
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=stephen.pederson@adelaide.edu.au

## Cores
CORES=2

## Modules
module load AdapterRemoval/2.2.1-foss-2016b
module load FastQC/0.11.7

## Directories
PROJROOT=/data/biohub/20190129_Lardelli_FMR1_RNASeq

## Setup for Trimmed data
RAWDATA=${PROJROOT}/0_rawData
TRIMDATA=${PROJROOT}/1_trimmedData
mkdir -p ${TRIMDATA}/fastq
mkdir -p ${TRIMDATA}/FastQC
mkdir -p ${TRIMDATA}/logs

##Trimming data
for R1 in ${RAWDATA}/fastq/*1.fq.gz
  do

    echo -e "Currently working on ${R1}"
    R2=${R1%1.fq.gz}2.fq.gz

    # Now create the output filenames
    out1=${TRIMDATA}/fastq/$(basename $R1)
    out2=${TRIMDATA}/fastq/$(basename $R2)
    BNAME=${TRIMDATA}/fastq/$(basename ${R1%1.fq.gz})
    echo -e "Output file 1 will be ${out1}"
    echo -e "Output file 2 will be ${out2}\n"

    echo "Trimming:\n\t ${R1}\n\t${R2}"
    # Trim
    AdapterRemoval \
      --gzip \
      --trimns \
      --trimqualities \
      --minquality 20 \
      --minlength 35 \
      --threads ${CORES} \
      --basename ${BNAME} \
      --output1 ${out1} \
      --output2 ${out2} \
      --file1 ${R1} \
      --file2 ${R2}

done

# Move the log files into their own folder
mv ${TRIMDATA}/fastq/*settings ${TRIMDATA}/logs

# Run FastQC
fastqc -t ${CORES} -o ${TRIMDATA}/FastQC --noextract ${TRIMDATA}/fastq/*[12].fq.gz