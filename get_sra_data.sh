#!/bin/bash

# conda activate msa

VAR=$(tail -n +2 SraRunTable.txt | cut -d ',' -f 1)

for i in ${VAR}
	do
		echo "(o) downloading sra entry: ${i}"
		fastq-dump --gzip --defline-qual '+' ${i}
		echo "(o) done downloading ${i}"   

	done

# muscle -clw -in muscle_input.fasta -out muscle_output.clw
