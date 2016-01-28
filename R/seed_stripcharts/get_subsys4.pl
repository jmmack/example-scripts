#!/usr/bin/env perl -w 
use strict; 

#---------------------------------------------------------------------------------------------------
#	Mar 19, 2013 - JM
#	After BLASTing the SEED database (using 1e-3 cutoff), take the best fig.peg hit and get the
#		subsys4 assignment.
#
#---------------------------------------------------------------------------------------------------

my $seed_blast;
#my $aldex;
#my $subsystems2peg = "/Volumes/rhamnosus/SEED_subsystems/subsystems2pegNA";
my $subsystems2peg = "/Groups/twntyfr/SEED_subsystems/subsystems2pegNA";


my $help = "\t-i is your -m 8 blast output to the SEED database. By default, the best hit is taken for each query\n";
#BC0001	fig|405532.4.peg.1	100.00	446	0	0	1	446	1	446	0.0	 885
#qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore

my $header = "refseq_id\tsubsys4\n";

if (@ARGV){
	my $i = 0;
	foreach my $item(@ARGV) {
		$i++;
		
		if ($item eq "-i"){
		   $seed_blast = $ARGV[$i];
#		}elsif ($item eq "-i"){
#			$aldex_output = $ARGV[$i};
		}
	}
} else {
print $help;
	exit;
}

my %subsys4_lookup;
open (INPUT, "< $subsystems2peg") or die "Could not open $subsystems2peg $!\n"; 
while (defined (my $line = <INPUT>)) { 
chomp ($line);
	my @hold = split (/\t/, $line);
	$subsys4_lookup{$hold[2]} = $hold[1];				#subsys4 lookup by fig.peg ID
}
close INPUT;

print $header;
my %seen;
open (INPUT, "< $seed_blast") or die "Could not open $seed_blast $!\n"; 
while (defined (my $line = <INPUT>)) { 
chomp ($line);
	my @hold = split (/\t/, $line);
	if (!exists $seen{$hold[0]}){
		print "$hold[0]\t$subsys4_lookup{$hold[1]}\n" if exists $subsys4_lookup{$hold[1]};
		print "$hold[0]\tnone\n" if !exists $subsys4_lookup{$hold[1]};
		$seen{$hold[0]} = "y";
	}
		
}
close INPUT;
