bwa index ref_genome.fasta

for filename in Bat Cat Guinea_pig Patient_10 Patient_11 Patient_12 Patient_13 Patient_14 Patient_15 Patient_16 Patient_1 Patient_2 Patient_3 Patient_4 Patient_5 Patient_6 Patient_7 Patient_8 Patient_9 Rabid_raccoon_1 Rabid_raccoon_2 Rabid_raccoon_3 Rabid_raccoon_4 ; do
   echo "Processing alignment for $filename and converting resulting SAM to BAM"
   bwa mem ref_genome.fasta /projects/micb405/resources/project_1/${filename}_1.fastq.gz /projects/micb405/resources/project_1/${filename}_2.fastq.gz | samtools view -b > ${filename}.bam
   echo "executed command bwa mem ref_genome.fasta ${filename}_1.fastq.gz ${filename}_2.fastq.gz | samtools view -b > ${filename}.bam"

   echo "Sorting, removing duplicates, and indexing for $filename"
   samtools sort ${filename}.bam > ${filename}_sorted.bam
   samtools rmdup ${filename}_sorted.bam ${filename}_sorted_rmdup.bam
   samtools index ${filename}_sorted_rmdup.bam
   echo "Done samtools sort, rmdup, and index for $filename"

   echo "Variant calling for $filename"
   bcftools mpileup --fasta-ref /projects/micb405/resources/project_1/ref_genome.fasta ${filename}_sorted_rmdup.bam | bcftools call -mv > ${filename}.vcf
   echo "Done variant calling for $filename"
done

echo "Converting all *.vcf to *.fasta"
python /projects/micb405/resources/vcf_to_fasta_het.py -x ~/project1/ output
echo "Done converting all *vcf to *.fasta"

echo "Creating MSA"
muscle -in output.fasta -out zombie_bacteria.mfa
trimal -automated1 -in zombie_bacteria.mfa -out zombie_bacteria_trimal.mfa
echo "Done creating MSA"

echo "Generating phylogenetic tree"
raxml-ng --all --msa zombie_bacteria_trimal.mfa --model LG+G2 --tree rand{4} --bs-trees 4 --threads 1 --seed 12345
echo "Done generating the phylogenetic tree"
