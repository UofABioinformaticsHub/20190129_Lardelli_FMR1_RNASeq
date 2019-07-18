#!/bin/bash
#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --time=4:00:00
#SBATCH --mem=16GB
#SBATCH -o /data/biohub/20190129_Lardelli_FMR1_RNASeq/slurm/%x_%j.out
#SBATCH -e /data/biohub/20190129_Lardelli_FMR1_RNASeq/slurm/%x_%j.err
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=stephen.pederson@adelaide.edu.au

## Cores
CORES=2

## Modules
module load FastQC/0.11.7

## Suffix at the end of all files
# This will be removed from the final bams
SUF=.fq.gz

## Directories
PROJROOT=/data/biohub/20190129_Lardelli_FMR1_RNASeq

## Directories for Initial FastQC
RAWDATA=${PROJROOT}/0_rawData
mkdir -p ${RAWDATA}/FastQC


##--------------------------------------------------------------------------------------------##
## FastQC on the raw data
##--------------------------------------------------------------------------------------------##

fastqc -t ${CORES} -o ${RAWDATA}/FastQC --noextract ${RAWDATA}/fastq/*${SUF}
