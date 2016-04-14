#!/usr/bin/env bash
#14Apr2016 JM

# Rename the sequences in the scaffold file by the genome ID
# concatenate them all into one file for a BLAST database

# This is my working directory
#/Volumes/iners/AL_biologicals/AL_genomes


for f in AFR97/*.final.scaffolds.fasta; do
#	echo $f
	B=`basename $f`

#	echo "basename: $B"
#	basename: A04.final.scaffolds.fasta

# Split on . and get the first field
	NAME=`echo $B | cut -d "." -f1`

#	echo "name: $NAME"
#	name: A04

#substitute the beginning of each header with the name (genome ID) of the file it comes from
	sed "s/>/>${NAME}_/g" $f > ${NAME}_scaffolds_named.fasta
done

# concatenated into one file and remove the temp files
	cat *_scaffolds_named.fasta > AFR97/all_scaffolds.ffn
	rm *_scaffolds_named.fasta

# Note: all output will be in the working directory by default (of course)


#See dirname also
# original: /Volumes/iners/AL_biologicals/AL_genomes/cat_genomes.sh
