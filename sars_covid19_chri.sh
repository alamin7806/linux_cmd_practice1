#!/bin/bash

# analysis of covid_19 genome sequence

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/009/858/895/GCF_009858895.2_ASM985889v3/GCF_009858895.2_ASM985889v3_genomic.fna.gz


bowtie2-build GCF_009858895.2_ASM985889v3_genomic.fna covid_19
bowtie2 -x covid_19 -1 SRR11801823_1.fastq.gz -2 SRR11801823_2.fastq.gz -S SRR11801823.sam 

prefetch SRR11801823
fastq-dump --gzip --defline-qual '+' --split-e SRR11801823/SRR11801823.sra 

fastqc *.fastq.gz
multiqc

samtools view -b -o SRR11801823.bam SRR11801823.sam
samtools sort -o SRR11801823.sort.bam SRR11801823.bam
samtools flagstat SRR11801823.sort.bam 
bcftools  mpileup -Ou -f GCF_009858895.2_ASM985889v3_genomic.fna -o SRR11801823.pileup.bcf SRR11801823.sort.bam
bcftools call -v -m -Ou -o SRR11801823.call.bam SRR11801823.pileup.bcf
bcftools norm -Ou -f GCF_009858895.2_ASM985889v3_genomic.fna -d all -o SRR11801823.norm.bcf SRR11801823.call.bcf 
bcftools view SRR11801823.call.bcf | grep -v '^#' | wc -l
