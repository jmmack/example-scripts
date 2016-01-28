#!/usr/bin/env perl -w 
use strict; 

#---------------------------------------------------------------------------------------------------
#	Mar 19, 2013 - JM
#	Take output from get_subsys4.pl (has gene_id, subsys4, and ALDEx output) and add the SEED hier
#		there will be a new line for each unique hierarchy per gene
#	ALDEx IDs WITHOUT a subsys4 (e.g. those with "none" will NOT be printed in the output)
#---------------------------------------------------------------------------------------------------

my $help = "\t-i is your input table with column header \"subsys4\"
	NOTE: IDs WITHOUT a subsys4 (e.g. those with \"none\") will NOT be printed in the output (but you wouldn't want to plot them anyway)
	Otuput is redirected with > with columns added for subsys1, subsys2, subsys3
	NOTE there will multiple lines with the same refseq+subsys4 if the subsys4 belongs to multple hierarchies\n";

##WARNING OCT 2013
# This is a fix to the original script that only printed the last refseq+subsys4. Make a really slow
#	foreach because my brain can't think of a better way right now
#Problem: multiple refseqs per subsys4 (input file) and multiple hierarchies per subsys4 (subsystems2role file)

my $input;
my $subsystems2role = "/Groups/twntyfr/SEED_subsystems/subsystems2roleNA";
#my $subsystems2role = "/Volumes/rhamnosus/SEED_subsystems/june2013/subsystems/subsystems2roleNA";
my %seen;

if (@ARGV){
	my $i = 0;
	foreach my $item(@ARGV) {
		$i++;
		if ($item eq "-i"){
		   $input = $ARGV[$i];
		}
	}
} else {
print $help;
	exit;
}

my $header;
my @header;
my $s4col = "-1";

my %data;		# Get input line lookup by refseq
my %subsys4;	# Get subsys4 lookup by refseq

open (INPUT, "< $input") or die "Could not open $input: $!\n"; 
while (defined (my $line = <INPUT>)) { 
chomp ($line);
	my @hold = split (/\t/, $line);
	if ($line !~ /^id/ && $line !~ /^refseq/ && $line !~ /^subsys4/){
#		$data{$hold[$s4col]} = $line;				# lookup by subsys4
		$data{$hold[1]} = $line;					# data lookup by refseqID
		$subsys4{$hold[1]} = $hold[$s4col];			# subsys4 lookup by refseqID
#print "$hold[-1]\n";
	}elsif ($line =~ /^id/ || $line =~ /^refseq/ || $line =~ /^subsys4/ || $line =~ /^\t/){		# Get the subsys4 col by name
		$header = $line;
#		push(@header, $line);
		for(my $i=0;$i<@hold;$i++){
			$s4col = $i if ($hold[$i] =~ m/subsys4/);
		}
		print "$header\tsubsys1\tsubsys2\tsubsys3\n";

#print "$s4col\n";
	}

}close INPUT;


open (INPUT, "< $subsystems2role") or die "Could not open $subsystems2role: $!\n"; 
while (defined (my $line = <INPUT>)) { 
chomp ($line);
	my @hold = split (/\t/, $line);
#	print "$data{$hold[-1]}\t$hold[1]\t$hold[2]\t$hold[0]\n" if exists $data{$hold[-1]};	#subsystems2role column order is: subsys3, subsys1, subsys2, subsys4

# Come to a subsys4 hier, there may be more
#The foreach will be stupidly slow but I can't think of another way right now: Each subsys4 could have multiple refseqs (input file)
#	and each subsys4 could have multiple hierarchies (subsystem2role file)
foreach (keys(%data)){
	print "$data{$_}\t$hold[1]\t$hold[2]\t$hold[0]\n" if  $hold[-1] eq $subsys4{$_};	#subsystems2role column order is: subsys3, subsys1, subsys2, subsys4
	# print refseq line (with subsys4), and the rest of the hierarchy for every refseq with a subsys4 matching the current line
	
}
	# ONLY the hierarchies that are in the $input file will be printed.
	$seen{$hold[-1]} = "";
}close INPUT;





# Use this if you want to see the subsys4 that were not found in the subsystems2role file
=this
foreach(keys(%data)){
	print "$_ was not found in subsystems2roleNA\n" if !exists $seen{$_};
}
=cut
