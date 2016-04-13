#!/usr/bin/env perl -w
use strict;

# June 12, 2013 - JM
#--------------------------------------------------------------------------------------------------
# NEED TO generalize this for build_database.sh

# Use this to make lookup table of .ffn IDs, the accession number, and the taxID
# 		- Will later use this to lookup full taxonomic lineage
#
#--------------------------------------------------------------------------------------------------

#my $rpt = $ARGV[0];
#e.g. /Volumes/rhamnosus/reference_genomes/may2013/reference_lists/wget/draft/Anaerococcus_hydrogenalis_ACS_025_V_Sch4_uid63589/NZ_AEXN00000000.rpt
#my $fasta = $ARGV[1];
#e.g. /Volumes/rhamnosus/reference_genomes/may2013/reference_lists/wget/draft/Anaerococcus_hydrogenalis_ACS_025_V_Sch4_uid63589/all.ffn

#my @dirs = qw(/Volumes/rhamnosus/reference_genomes/may2013/wget/complete /Volumes/rhamnosus/reference_genomes/may2013/wget/draft);
my @dirs = qw(complete draft);
my $omit = "all.ffn";									#in /draft dirs this is the cat of all the separate .ffn files. Don't want to include this in list or everything will be duplicated
my $header = "seqID\tlength\taccession\ttaxID\n";

print $header;

#for each dir (/complete and /draft)
foreach my $dir(@dirs){

my @ls = `ls $dir`;										#get list of organism-specific dirs

	foreach my $org (@ls){
	chomp($org);
	chdir "$dir/$org";
	my %accession; my %taxid;							#clear variables

			my @rpt = glob("*.rpt");					#can be multiple .rpt
			my @f = glob("*.ffn");						#can be multiple .ffn
			foreach(@rpt){
			chomp($_);
			my $rpt = $_;
			my @name = split(/\./, $_);
				open (INPUT, "< $rpt") or die "Could not open $rpt: $!\n";
				while(my $l = <INPUT>) {
				chomp ($l);
					my @hold = split (/\s+/, $l);
					if ($dir =~ m/complete/){						#multiple accessions
						$accession{$name[0]} = $hold[-1] if ($l =~ m/^Accession/);
						$taxid{$name[0]} = $hold[-1] if ($l =~ m/^Taxid/);
					}elsif ($dir =~ m/draft/){						#single accessions
						$accession{$org} = $hold[-1] if ($l =~ m/^Accession/);
						$taxid{$org} = $hold[-1] if ($l =~ m/^Taxid/);
					}
				}close INPUT;
			}
			
@f = grep { $_ ne $omit } @f;				#get rid of all.ffn from consideration. Only want original .ffn files and no duplicates
			foreach(@f){
			chomp($_);
			my $ffn = $_;
			my @name = split(/\./, $_);
				open (INPUT, "< $ffn") or die "Could not open $ffn: $!\n";
				my %seq;
				my $fasta_header;
				while(my $l = <INPUT>) {
				chomp ($l);
					if ($l =~ m/^>/){
					$fasta_header = $l;
#						print "$l\t$accession{$name[0]}\t$taxid{$name[0]}\n" if $dir =~ m/complete/;
#						print "$l\t$accession{$org}\t$taxid{$org}\n" if $dir =~ m/draft/;
					}elsif ($l !~ m/^>/){
						$seq{$fasta_header} .= $l;
					}
				}close INPUT;
				
				foreach(keys(%seq)){
					my $length = length($seq{$_});
					print "$_\t$length\t$accession{$name[0]}\t$taxid{$name[0]}\n" if $dir =~ m/complete/;
					print "$_\t$length\t$accession{$org}\t$taxid{$org}\n" if $dir =~ m/draft/;
				}
			}
	}
}