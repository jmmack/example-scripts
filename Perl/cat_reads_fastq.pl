#!/usr/bin/env perl -w
use strict;

#---------------------------------------------------------------------------------------------------
# 16Mar2016 - JM
# This will take two paired reads FASTQ files (with paired reads in the same order) and concatenate
#	the reads and quality scores together into one FASTQ output
# There is NO overlapping
#---------------------------------------------------------------------------------------------------

my $read1 = $ARGV[0];
my $read2 = $ARGV[1];
#ext0442:16S_Mar2016 mmacklai$ ./cat_reads.pl trimmed_R1.fastq trimmed_R2.fastq > reads_cat.fastq


my $count=0;	#counter for fastq, every read is 4 lines
my $qual;	#quality scores
my $seq;	#sequences
my $head;	# read header


open (my $IN1, "<", $read1) or die "$!\n";
open (my $IN2, "<", $read2) or die "$!\n";
while( not eof $IN1 and not eof $IN2){
    my $l1 = <$IN1>;
    my $l2 = <$IN2>;
    chomp $l1; chomp $l2;

#    print "$l1\n$l2\n";exit;

	$count++;

#print "$count\n"; exit;

	if ($count == 1){
		my @s = split(/\s+/, $l1);
		$head = $s[0]; #keep the header from one file only (they should be the same except for the pairing information)
	}elsif ($count == 2){
		my $rev_seq = reverse_complement($l2);		# Need the reverse complement of read2
		$seq = "$l1$rev_seq";	#cat the read1 and read2 sequences together

	}elsif ($count == 4){
		$qual = "$l1$l2";	# cat the quality scores together
		print "$head\n$seq\n+\n$qual\n";	#print in same order/format as fastq
		$count=0;
	}
}
close $IN1;
close $IN2;


sub reverse_complement {
        my $dna = shift;

	# reverse the DNA sequence
        my $revcomp = reverse($dna);

	# complement the reversed DNA sequence
        $revcomp =~ tr/ACGTacgt/TGCAtgca/;
        return $revcomp;
}
