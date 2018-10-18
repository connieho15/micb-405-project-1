#!/bin/bash

bwa_index ref_genome.fasta

for filename in Bat Cat Guinea_pig Patient_10 Patient_11 Patient_12 Patient_13 Patient_14 Patient_15 Patient_16 Patient_1 Patient_2 Patient_3 Patient_4 Patient_5 Patient_6 Patient_7 Patient_8 Patient_9 Rabid_racoon_1 Rabid_racoon_2 ; do
	echo "Processing alignment for - $filename"
    bwa mem ref_genome.fasta "~/project_1/rawdata/project_1/${filename}_1.fastq.gz ~/project_1/rawdata/project_1/${filename}_2.fastq.gz > ${filename}_outfile.sam"
done
