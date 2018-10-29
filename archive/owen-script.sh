#!/bin/bash

echo "Indexing Reference Genome" 

bwa index -p ~/Project_1/indexedRef/ref_genome_indexed /projects/micb405/resources/project_1/ref_genome.fasta

for filename in Bat Cat Guinea_pig Patient_10 Patient_11 Patient_12 Patient_13 Patient_14 Patient_15 Patient_16 Patient_1 Patient_2 Patient_3 Patient_4 Patient_5 Patient_6 Patient_7 Patient_8 Patient_9 Rabid_raccoon_1 Rabid_raccoon_2 Rabid_raccoon_3 Rabid_raccoon_4 ; do
	echo "Processing Alignment for - $filename"
	bwa mem -t 2 ~/Project_1/indexedRef/ref_genome_indexed /projects/micb405/resources/project_1/${filename}_1.fastq.gz /projects/micb405/resources/project_1/${filename}_2.fastq.gz >~/Project_1/${filename}.sam
    echo "Coverting $filename.sam to $filename.bam"
    samtools view -b  ~/Project_1/${filename}.sam > ~/Project_1/${filename}.bam
    echo "Sorting $filename.bam"
    samtools sort ${filename}.bam -o ${filename}.sorted
    echo "Indexing $filename"
    samtools index ${filename}.sorted
    echo "Generating pileup file for $filename"
    samtools mpileup -q 30 -u -f /project_1/ref_genome.fasta ${filename}.sorted > ${filename}.bcf -I
    echo "Converting pileup file to human readable format - $filename"
    bcftools call -O v -mv ${filename}.bcf > ${filename}.vcf
done


