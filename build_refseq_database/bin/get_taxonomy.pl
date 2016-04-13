#!/usr/bin/env perl -w
use strict;

#---------------------------------------------------------------------------------------------------
# Dec 5, 2011 - JM (original)
# June 12, 2013 (this version)
#----------------------------
#
# Lookup by TaxID on NCBI and get taxonomic lineage e.g.:
#	Bacteria;Firmicutes;Bacilli;Lactobacillales;Lactobacillaceae;Lactobacillus;iners;AB-1
# Will keep a hash of each taxid that have already been looked up 
#
#---------------------------------------------------------------------------------------------------
my $help = "\tFirst argument is your lookup table with first col containing seqIDs and last col containing taxIDs (e.g. all_bac.ffn_lookup.txt)
\tRe-direct output and curl log (e.g.2> temp.txt > all_bac.ffn_lookup_tax.txt)
\trm temp.txt when you are done\n";
print $help if !$ARGV[0];exit if !$ARGV[0];

my $file = $ARGV[0];
#e.g. /Volumes/rhamnosus/reference_genomes/may2013/reference_lists/wget/all_bac.ffn_accession_lookup.txt
#seqID	length	accession	taxID
#>gi|326802614|ref|NC_015278.1|:1064335-1064811 Aerococcus urinae ACS-120-V-Col10a chromosome, complete genome	477	NC_015278.1	866775


my %seen;

#my $kingdom; my $phylum; my $class; my $order; my $family; my $genus; my $species; my $strain;

my @list = qw(superkingdom phylum class order family genus species);		#These match the names given by NCBI. Also makes sure all lineages will have the same hierarchy (e.g. no extra subfamilies etc.)
my $strain;

print "refseqID	length	accession	taxID	taxonomy\n";
open (INPUT, "< $file") or die "Could not open $file\n";
while(defined (my $l = <INPUT>)) {
chomp ($l);
if ($l !~ /^seq/){

	my @taxonomy = ();
	my @array = split (/\t/, $l);
	my $taxid = $array[-1];													#Expecting the NCBI taxID to be the last column
	
	if (!exists $seen{$taxid}){
			my @out = `curl 'http://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=$taxid&lvl=0'`;	#lookup by taxid
			
			for (my $i=0; $i<@out; $i++){
				if ($out[$i] =~ m/TITLE="superkingdom"/){						#Find the line with the lineage
					foreach(@list){
						if ($out[$i] =~ m/TITLE="$_"/){							# Some do not have full lineage and instead are marked as "no rank" e.g. taxid:699246
							my @split1 = split (/TITLE="$_"\>/, $out[$i]);		#Go through ea. level in @list and extract the entry
							my @split2 = split(/\<\/a\>/, $split1[-1]);
							
							if ($_ eq "species"){								# Species is listed as "genus species" so split them and get only species
	#							print "$split2[0]\n";
								my @split = split(/\s+/, $split2[0]);
								push(@taxonomy, $split[-1]);
	#							print "$split[-1]\n";
								
							}else{
								push(@taxonomy, $split2[0]);
							}
						}else{
							push(@taxonomy, "unclassified");				# If no entry for a level
						}
					}
		
				}elsif ($out[$i] =~ m/Taxonomy browser/){					# Strain information is not with the rest of the Lineage. It's extracted here
					my @split = split(/[()]/, $out[$i]);
					my @split1 = split(/\s+/, $split[1]);
					$strain = join(' ', @split1[2..(@split1-1)]);
					$strain = "unclassified" if !exists $split1[2];			# Account for if there is no species
#					print "$strain\n";

				}
			
			}
		
					my $lineage = join(";", @taxonomy, $strain);			# Join with ; in QIIME-style taxonomy
					$seen{$taxid} = $lineage;
								
					print "$l\t$lineage\n";
					$lineage = ();
	}elsif (exists $seen{$taxid}){											#Only curl when taxid hasn't been seen already. This lookup is faster if you've seen it
		print "$l\t$seen{$taxid}\n";
	}
}
}close INPUT;
