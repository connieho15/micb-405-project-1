#!/bin/bash                                                                                                   

mkdir Project1
cp /projects/micb405/resources/project_1/ref_genome.fasta ~/Project1
cd Project1
bwa index ref_genome.fasta

for filename in Bat Cat Guinea_pig Patient_10 Patient_11 Patient_12 Patient_13 Patient_14 Patient_15 Patient_16 Patient_1 Patient_2 Patient_3 Patient_4 Patient_5 Patient_6 Patient_7 Patient_8 Patient_9 Rabid_raccoon_1 Rabid_raccoon_2 Rabid_raccoon_3 Rabid_raccoon_4 ; do
    echo "Processing alignment for - $filename"
    bwa mem -t 2 ref_genome.fasta /projects/micb405/resources/project_1/${filename}_1.fastq.gz /projects/micb405/resources/project_1/${filename}_2.fastq.gz > ${filename}_outfile.sam
    echo "Done alignment - $filename"
    echo "Converting SAM to BAM for - $filename"
    samtools view -b ${filename}_outfile.sam > ${filename}.bam
    echo "Done converting - $filename"
    echo "Sorting BAM - $filename"
    samtools sort ${filename}.bam -o ${filename}.sorted
    echo "Done sorting - $filename"
    echo "Removing Duplicates - $filename"
    samtools rmdup ${filename}.sorted ${filename}_rmdup.sorted
    echo "Done removing duplicates - $filename"
    echo "Indexing BAM - $filename"
    samtools index ${filename}_rmdup.sorted
    echo "Done indexing - $filename"
    echo "Running mpileup - $filename"
    samtools mpileup -q 30 -u -f ref_genome.fasta ${filename}_rmdup.sorted > ${filename}.bcf -I
    echo "Done mpileup - $filename"
    echo "Converting to BCF - $filename"
    bcftools call -O v -mv ${filename}.bcf > ${filename}.vcf
    echo "Done conversion to BCF - $filename"
done

echo "Creating MSA"
python /projects/micb405/resources/vcf_to_fasta_het.py -x ~/Project1/ output
muscle -in output.fasta -out result.mfa
trimal -automated1 -in result.mfa -out result_trimal.mfa
echo "Done creating MSA"

echo "Creating phylogenetic Tree"
raxml-ng --all --msa result_trimal.mfa --model LG+G2 --tree rand{4} --bs-trees 4 --threads 1 --seed 12345
echo "Done generating phylogenetic tree"

