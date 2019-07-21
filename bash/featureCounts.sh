#!/bin/bash
#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 2
#SBATCH --time=4:00:00
#SBATCH --mem=8GB
#SBATCH -o /data/biohub/20190129_Lardelli_FMR1_RNASeq/slurm/%x_%j.out
#SBATCH -e /data/biohub/20190129_Lardelli_FMR1_RNASeq/slurm/%x_%j.err
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=stephen.pederson@adelaide.edu.au

## Cores
CORES=2

##Load modules
module load Subread/1.5.2-foss-2016b

## Directories
PROJROOT=/data/biohub/20190129_Lardelli_FMR1_RNASeq
ALIGNDATA=${PROJROOT}/2_alignedData

## Genomic Data Files
REFS=/data/biorefs/reference_genomes/ensembl-release-94/danio-rerio
GTF=${REFS}/Danio_rerio.GRCz11.94.chr.gtf.gz

## Feature Counts - obtaining all sorted bam files
sampleList=`find ${ALIGNDATA}/bams -name "*out.bam" | tr '\n' ' '` #creates list of bam files, replacing new line with a space

## Running featureCounts on the sorted bam files 
#-Q min quality read score, 
#-s strand specific 0=unstranded, 1= stranded, 2 = reversely stranded
#--fracOverlap is minimum fraction of overlapping bases in a read required for read assignment (1 = 100%)
#-a annotation file
#-o output file name
zcat ${GTF} > temp.gtf
featureCounts \
	-Q 10 \
	-s 2 \
	--fracOverlap 1 \
	-T ${CORES} \
	-a temp.gtf \
	-F GTF \
	-o ${ALIGNDATA}/featureCounts/counts.out ${sampleList}
rm temp.gtf

## Remove columns 2-6 and row 1 of the output
cut -f1,7- ${ALIGNDATA}/featureCounts/counts.out | sed 1d > ${ALIGNDATA}/featureCounts/genes.out

