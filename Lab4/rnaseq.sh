#!/usr/bin/env

echo $0 $1

set -e # Fail on error

# FILE = 2cells
FILE = ${${1}:-"2cells"}
echo $FILE


# == 1 ========================================================================= 
FastQC=output/FastQC
mkdir -p $FastQC
tools/FastQC/fastqc -o $FastQC -t 2 --extract --nogroup data/${FILE}_*.fastq


# == 2 ========================================================================= 
TRIM=output/Trim
mkdir -p $Trim
java -jar tools/Trimmomatic-0.36/trimmomatic-0.36.jar PE \
  -threads 4 -phred33 \
  data/${FILE}_1.fastq data/${FILE}_2.fastq \
  $TRIM/${FILE}_1.trim.fastq $TRIM/${FILE}_1.trim.unpaired.fastq \
  $TRIM/${FILE}_2.trim.fastq $TRIM/${FILE}_2.trim.unpaired.fastq \
  LEADING:20 TRAILING:20 AVGQUAL:20 MINLEN:25


# == 3 ========================================================================= 
HISAT2=output/Hisat2
mkdir -p $Hisat2
tools/hisat2-2.2.1/hisat2-build data/danRer10.chr12.fa $HISAT2/danRer10.chr12


# == 4 ========================================================================= 
HISAT2=output/Hisat2
TRIM=output/Trim
SAM=output/Sam
mkdir -p $SAM
tools/hisat2-2.2.1/hisat2 -q \
-x $HISAT2/danRer10.chr12 \
-1 $TRIM/${FILE}_1.trim.fastq \
-2 $TRIM/${FILE}_2.trim.fastq \
-S $SAM/${FILE}.sam &> $SAM/${FILE}.log
cat $SAM/${FILE}.log


# == 5 ========================================================================= 
SAM=outputs/Sam
BAM=outputs/Bam
mkdir -p $BAM
tools/samtools-1.16.1/samtools view -bS $SAM/${FILE}.sam > $BAM/${FILE}.bam


# == 6 =========================================================================
BAM=outputs/Bam
tools/samtools-1.16.1/samtools sort -o $BAM/${FILE}_sorted.bam $BAM/${FILE}.bam


# == 7 ========================================================================= 
BAM=outputs/Bam
tools/samtools-1.16.1/samtools index $BAM/${FILE}_sorted.bam
