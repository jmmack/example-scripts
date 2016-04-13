#!/usr/bin/env perl -w
use strict;
#---------------------------------------------------------------------------------------------------
# 31-May-2013, JM
#### Running examples #####
#./wget_ncbi_genomes.pl file.txt 2> wget_log.txt
#nohup ./wget_ncbi_genomes.pl ../hmp_plus_old_ncbi.txt 2> wget_log_ptt.txt &
#nohup ../wget_ncbi_genomes.pl ../../archaea_ncbi.txt 2> wget_log.txt &

#From a list of genomes (where the organism names matches the NCBI directory name - see the README)
#	get the .ffn and .faa files and organize them into directories by organism name
# NOTE that the complete and draft genomes have different directroy structure. YOU MUST HAVE A
#	/complete and /draft directory already made
#---------------------------------------------------------------------------------------------------
#my $file1 = "/Volumes/rhamnosus/reference_genomes/may2013/reference_lists/wget/hmp_ncbicomplete.txt";			# list of organisms with complete genomes
#my $file2 = "/Volumes/rhamnosus/reference_genomes/may2013/reference_lists/wget/hmp_ncbidraft.txt";				# list of organisms with draft genomees
my $file = $ARGV[0];

my $help = "\tARGV[0] is your list of organisms with names matching NCBI (except for _ and _uid)
\tYou MUST first copy and save the directory lists from NCBI and hard-code into this script
\tYou MUST have directories named complete and draft in your running directory
\tOutput will be .ffn .faa .ptt .rpt files for each of your listed organisms (separate dirs) in /draft or /complete\n";
print $help if !$ARGV[0];exit if !$ARGV[0];

#You MUST get up-to-date lists or the uid may not match
my $file_complete = "/Volumes/rhamnosus/reference_genomes/may2013/reference_lists/ncbi_bacteria_dir_11jun2013.txt";			# Directory list from NCBI (to match the names exactly)
my $file_draft = "/Volumes/rhamnosus/reference_genomes/may2013/reference_lists/ncbi_bacteria_draft_dir_11jun2013.txt";		# ""

#-------------------------
# For complete genomes
#-------------------------
my %lookup_complete;

open (IN, "< $file_complete") or die "Could not open $file_complete: $!\n";
while(defined(my $l = <IN>)){
chomp $l;	
	if ($l =~ m/__uid/){										# Sometimes there are 2 underscores and sometimes 1 in file names
	my @hold = split(/\__uid/, $l);
		my $tax = $hold[0];
#	print "$hold[0]\n$hold[1]\n";close IN;exit;
		$lookup_complete{$hold[0]} = "__uid" . $hold[1];
#	print "$lookup_complete{$hold[0]}\n";close IN;exit;
	}else{
	my @hold = split(/\_uid/, $l);
		my $tax = $hold[0];
	#	print "$hold[0]\n$hold[1]\n";close IN;exit;
		$lookup_complete{$hold[0]} = "_uid" . $hold[1];

	}
	
} close IN;

#-------------------------
# For draft genomes
#-------------------------
# Draft genomes are .tgz files with each scaffold a separate file

my %lookup_draft;

open (IN, "< $file_draft") or die "Could not open $file_draft: $!\n";
while(defined(my $l = <IN>)){
chomp $l;
	if ($l =~ m/__uid/){										# Sometimes there are 2 underscores and sometimes 1 in file names
	my @hold = split(/\__uid/, $l);
		my $tax = $hold[0];
		$lookup_draft{$hold[0]} = "__uid" . $hold[1];
	}else{
	my @hold = split(/\_uid/, $l);
		my $tax = $hold[0];
		$lookup_draft{$hold[0]} = "_uid" . $hold[1];

	}
	
} close IN;

open (IN, "< $file") or die "Could not open $file: $!\n";
while(defined(my $l = <IN>)){
chomp $l;
	my $tax = $l;
	$tax =~ s/ /_/g;					#spaces have to be changed to _ for the directroy name to match
	$tax =~ s/genomosp_/genomosp__/g;	# these have 2 underscores instead of 1 for some reason
	
#	print "$tax\n";close IN;exit;
	
#	print "$tax" . "$lookup_complete{$tax}\n" if exists $lookup_complete{$tax};
	
	if (exists $lookup_complete{$tax}){
		my $dir = "complete/$tax";
		if (!-d $dir){
			system(`mkdir $dir`);				# make new directory named by organism like NCBI
		}
#		system(`wget "ftp://ftp.ncbi.nlm.nih.gov/genomes/Bacteria/$tax$lookup_complete{$tax}/*.ffn" -P $dir`) if exists $lookup_complete{$tax};		# CDS (nt)
#		system(`wget "ftp://ftp.ncbi.nlm.nih.gov/genomes/Bacteria/$tax$lookup_complete{$tax}/*.faa" -P $dir `) if exists $lookup_complete{$tax};	# CDS (AA)
#		system(`wget "ftp://ftp.ncbi.nlm.nih.gov/genomes/Bacteria/$tax$lookup_complete{$tax}/*.ptt" -P $dir `) if exists $lookup_complete{$tax};	# Protein-coding summary table
		system(`wget "ftp://ftp.ncbi.nlm.nih.gov/genomes/Bacteria/$tax$lookup_complete{$tax}/*.frn" -P $dir `) if exists $lookup_complete{$tax};	# RNA
#check if there were genes (if there is a .ffn file)
		my @glob = glob("$dir/*.ffn");
#		system(`wget "ftp://ftp.ncbi.nlm.nih.gov/genomes/Bacteria/$tax$lookup_complete{$tax}/*.rpt" -P $dir `) if (exists $lookup_complete{$tax} && @glob >0);	#.rpt summary table. Only want this if there is actually gene information
#print "$dir/.ffn does not exist!\n" if @glob<1;
	}elsif (exists $lookup_draft{$tax} && !exists $lookup_complete{$tax}){
		my $dir = "draft/$tax";
		if (!-d $dir){
			system(`mkdir $dir`);				# make new directory named by organism like NCBI
		}
#		system(`wget "ftp://ftp.ncbi.nlm.nih.gov/genomes/Bacteria_DRAFT/$tax$lookup_draft{$tax}/*.ffn.tgz" -P $dir`) if exists $lookup_draft{$tax};		#.ffn
#		system(`wget "ftp://ftp.ncbi.nlm.nih.gov/genomes/Bacteria_DRAFT/$tax$lookup_draft{$tax}/*.faa.tgz" -P $dir `) if exists $lookup_draft{$tax};	#.faa
#		system(`wget "ftp://ftp.ncbi.nlm.nih.gov/genomes/Bacteria_DRAFT/$tax$lookup_draft{$tax}/*.ptt.tgz" -P $dir `) if exists $lookup_draft{$tax};	#.ptt
		system(`wget "ftp://ftp.ncbi.nlm.nih.gov/genomes/Bacteria_DRAFT/$tax$lookup_draft{$tax}/*.frn.tgz" -P $dir `) if exists $lookup_draft{$tax};	# RNA
#check if there were genes (if there is a .ffn file)
		my @glob = glob("$dir/*.ffn.tgz");
#		system(`wget "ftp://ftp.ncbi.nlm.nih.gov/genomes/Bacteria_DRAFT/$tax$lookup_draft{$tax}/*.rpt" -P $dir `) if (exists $lookup_draft{$tax} && @glob >0);	#.rpt summary table. Only want this if there is actually gene information
#print "$dir/.ffn does not exist!\n" if @glob<1;
	}else{
		print "$tax not found\n";
	}

} close IN;

