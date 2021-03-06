#!/usr/bin/env bash
#BSUB -J simulation[1-60]
#BSUB -e logs/simulate_replicates_%J.log
#BSUB -o logs/simulate_replicates_%J.out
#BSUB -R "select[mem>4] rusage[mem=4] span[hosts=1]"
#BSUB -q normal
#BSUB -P Sikela

lengths_to_sim="36 50 100 150 300 600"
base_coverage=15
fastq_folder=fastq/replicates
bed_ref=reference/hg38_all_regions_10Mb_merged.bed
GENOME=$HOME/genomes/bowtie2.2.5_indicies/hg38/hg38.fa
copies=2
READ_LENGTH=()
REPLICATE=()
for i in $lengths_to_sim
do
	for j in {1..10}
	do
		READ_LENGTH+=($i)
	done
done
for i in ${READ_LENGTH[@]}
do
	for j in {1..10}
	do
		REPLICATE+=($j)
	done
done

read_length=${READ_LENGTH[$(($LSB_JOBINDEX - 1))]}
replicate=${REPLICATE[$(($LSB_JOBINDEX - 1))]}

# Generate directores if necessary

if [ ! -d "logs" ]; then
  mkdir -p logs
fi

if [ ! -d "$fastq_folder" ]; then
  mkdir -p $fastq_folder
fi

code/simulate_reads.sh -b $base_coverage -c $copies -l $read_length -r $replicate $fastq_folder $bed_ref

prefix=$fastq_folder/template_${read_length}bp_${copies}x_$replicate

cut -f 4-9   ${prefix}_short.bed > ${prefix}_1.bed
cut -f 10-15 ${prefix}_short.bed > ${prefix}_2.bed

temp=$prefix
for pair in 1 2
do
	prefix=${temp}_$pair
    echo "getting sequence for simulated read positions"
	bedtools getfasta -name -s -fi $GENOME -bed $prefix.bed -fo $prefix.fa

    echo "converting fasta file to fastq"
	code/fasta2fastq.pl -f $prefix.fa -e data/qualities_R${pair}_${read_length}bp.txt -o $prefix.fastq
	rm $prefix.bed
	rm $prefix.fa
	gzip -f $prefix.fastq
done



