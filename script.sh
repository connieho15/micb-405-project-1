#!/bin/bash

bwa_index ref_genome.fasta

for filename in /~/project_1/rawdata/project_1/*.fastq.gz; do
	echo "Processing file - $filename"
    bwa mem ref_genome.fasta "$filename"
done
