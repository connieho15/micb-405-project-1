#!/bin/bash                                                                                                   5,1           All#!/bin/bash

bwa_index ref_genome.fasta

for filename in Bat Cat Guinea_pig Patient_10 Patient_11 Patient_12 Patient_13 Patient_14 Patient_15 Patient_16 Patient_1 Patient_2 Patient_3 Patient_4 Patient_5 Patient_6 Patient_7 Patient_8 Patient_9 Rabid_raccoon_1 Rabid_raccoon_2 Rabid_raccoon_3 Rabid_raccoon_4 ; do
    echo "Processing alignment for - $filename"
    bwa mem ref_genome.fasta ${filename}_1.fastq.gz ${filename}_2.fastq.gz > ${filename}_outfile.sam
    echo "executing command bwa mem ref_genome.fasta ${filename}_1.fastq.gz {filename}_2.fastq.gz > ${filename}_outfile.sam"
done

# For this step - may be beneficial to add -F 4 flag to filter out reads that are unmapped
for filename in Bat Cat Guinea_pig Patient_10 Patient_11 Patient_12 Patient_13 Patient_14 Patient_15 Patient_16 Patient_1 Patient_2 Patient_3 Patient_4 Patient_5 Patient_6 Patient_7 Patient_8 Patient_9 Rabid_raccoon_1 Rabid_raccoon_2 Rabid_raccoon_3 Rabid_raccoon_4 ; do
    echo "Converting SAM to BAM for - $filename"
    samtools view -b ~/${filename}_outfile.sam > ${filename}.bam
    echo "Done converting - $filename"
done

for filename in Bat Cat Guinea_pig Patient_10 Patient_11 Patient_12 Patient_13 Patient_14 Patient_15 Patient_16 Patient_1 Patient_2 Patient_3 Patient_4 Patient_5 Patient_6 Patient_7 Patient_8 Patient_9 Rabid_raccoon_1 Rabid_raccoon_2 Rabid_raccoon_3 Rabid_raccoon_4 ; do
    echo "Sorting BAM - $filename"
    samtools sort ${filename}.bam -o ${filename}.sorted
    echo "Done sorting - $filename"
done

# Should add step to remove duplicates here 

# Example: samtools rmdup \
# ~/ProcessedData/BWA_output/B_hinzii.VS.F01.sorted.bam \
# ~/ProcessedData/BWA_output/B_hinzii.VS.F01.sorted.rmdup.bam

for filename in Bat Cat Guinea_pig Patient_10 Patient_11 Patient_12 Patient_13 Patient_14 Patient_15 Patient_16 Patient_1 Patient_2 Patient_3 Patient_4 Patient_5 Patient_6 Patient_7 Patient_8 Patient_9 Rabid_raccoon_1 Rabid_raccoon_2 Rabid_raccoon_3 Rabid_raccoon_4 ; do
    echo "Indexing BAM - $filename"
    samtools index ${filename}.sorted
    echo "Done indexing - $filename"
done

# Tutorial used bcftools here instead of samtools
# bcftools mpileup --fasta-ref ~/ProcessedData/BWA_output/B_hinzii_index.fna \
# ~/ProcessedData/BWA_output/B_hinzii.VS.F01.sorted.rmdup.bam | bcftools call -mv - \
# >~/ProcessedData/BWA_output/B_hinzii.VS.F01.raw.vcf

for filename in Bat Cat Guinea_pig Patient_10 Patient_11 Patient_12 Patient_13 Patient_14 Patient_15 Patient_16 Patient_1 Patient_2 Patient_3 Patient_4 Patient_5 Patient_6 Patient_7 Patient_8 Patient_9 Rabid_raccoon_1 Rabid_raccoon_2 Rabid_raccoon_3 Rabid_raccoon_4 ; do
    echo "Running mpileup - $filename"
    samtools mpileup -q 30 -u -f ~/project_1/reference_genome/ref_genome.fasta processed/${filename}.sorted > ${filename}.bcf -I
    echo "Done mpileup - $filename"
done

for filename in Bat Cat Guinea_pig Patient_10 Patient_11 Patient_12 Patient_13 Patient_14 Patient_15 Patient_16 Patient_1 Patient_2 Patient_3 Patient_4 Patient_5 Patient_6 Patient_7 Patient_8 Patient_9 Rabid_raccoon_1 Rabid_raccoon_2 Rabid_raccoon_3 Rabid_raccoon_4 ; do
    echo "Converting to BCF - $filename"
    bcftools call -O v -mv ${filename}.bcf > ${filename}.vcf
    echo "Done conversion to BCF - $filename"
done

python vcf_to_fasta_het.py -x ~/project_1/ output.fasta
muscle -in output.fasta -out result.mfa
FastTree result.mfa > tree.nwk
