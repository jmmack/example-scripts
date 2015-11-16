#!/usr/bin/env perl -w
use strict;

# Mar 4, 2013
# JM
# Will print out a table of headers, blast headers (split on first \s) and the sequence length

my $fasta = $ARGV[0];

my %seqs;
my %defs;
my $def;

open (INPUT, "< $fasta") or die "Could not open $fasta: $!\n";
while(defined (my $line = <INPUT>)) {
chomp ($line);

	if ($line =~ m/^>/){
		$def = $line;
		$def =~ s/>//;
		my @hold = split(/\s/, $line);
		$hold[0] =~ s/>//;
		$defs{$def} = $hold[0];
	}elsif ($line !~ m/^>/ && defined($def)){
		$seqs{$def} .= $line;
	}
			
}close INPUT;

my $header = "defline\tshort_defline\tseq_length\n";
print $header;

foreach(keys(%defs)){
	my $length = length($seqs{$_});
	print "$_\t$defs{$_}\t$length\n";
}
