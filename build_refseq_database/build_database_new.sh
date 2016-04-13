#!/usr/bin/env bash
#May/June 2013 - JM

#---------------------------------------------------------------------------------------------------
# This pipeline is for building a bacterial coding sequence database. The same steps could be
#	repeated to make an archaeal database. I chose to build these separately since uclust can't
#	handle too many seq at once and the archaeal and bacterial CDS tend not to cluster together	
#
#---------------------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------
# If you are adding genomes NOT from NCBI wget do the following:
#	- Add to "draft" folder with the directory named for the organism. The dir must have the
#		following:
#			- .ffn file containing all gene nt seqs with unique fasta headers
#			- .faa for translated seqs
#			- .rpt summary table with the accession and taxid (see examples)
#
#---------------------------------------------------------------------------------------------------

LOG_FILE="build_database_log_`date +"%Y-%m-%d_%H%M%S"`.txt"
WORKING_DIR="/Volumes/rhamnosus/reference_genomes/may2013/wget"
BIN="/Volumes/rhamnosus/reference_genomes/may2013/bin"

# List of directroy structures. These dirs must be present in you working dir
#DIRS=( complete draft archaea/complete archaea/draft )
#DRAFT_DIRS=( draft archaea/draft )
#COMP_DIRS=( complete archaea/complete )
BAC_DIRS=( complete draft )

BAC_LIST="/Volumes/rhamnosus/reference_genomes/may2013/reference_lists/hmp_plus_old_ncbi.txt"
ARC_LIST="/Volumes/rhamnosus/reference_genomes/may2013/reference_lists/archaea_ncbi.txt"

#---------------------------------------------------------------------------------------------------
#1) Make a list of genomes to pull based on what's avail. in the ncbi directories
#---------------------------------------------------------------------------------------------------
#	(details:/Volumes/rhamnosus/reference_genomes/may2013/reference_lists/README)
#	IMPORTANT INFO: Make sure the names are going to match the NCBI database (except for _ and _uidNNNN)
#					Make sure there are no duplicates in the list (can use unique() in R to filter)
#

ORG_LIST=$BAC_LIST

#---------------------------------------------------------------------------------------------------
#2) Use wget to acquire the seqs for complete and draft genomes
#---------------------------------------------------------------------------------------------------

cd /Volumes/rhamnosus/reference_genomes/may2013/wget
# Need directories for complete and draft genomes. Files will be filled in assorted by draft or complete
#	then the organism name. Mimics the NCBI structure.
if [ ! -d "complete" ]; then
	mkdir complete
fi
if [ ! -d "draft" ]; then
	mkdir draft
fi

# Get the needed files from NCBI from a list of organisms
# See Perl script for the files collected. .ffn, .faa, .ptt, .rfn, .rpt
nohup ./wget_ncbi_genomes.pl $ORG_LIST 2> wget_log.txt &

cp nohup.out wget_notfound.txt
rm nohup.out


cd $WORKING_DIR

#---------------------------------------------------------------------------------------------------
#3) Remove all empty dirs (these have directories on NCBI but the files are missing)
#---------------------------------------------------------------------------------------------------
#	Keep track of removed dirs

echo "the following empty directories were removed:" >>$LOG_FILE

for i in ${BAC_DIRS[@]}; do
	find ${i} -type d -empty -exec rmdir {} \; 2>>$LOG_FILE
done

#remove duplicates
#rm draft/*/*.1
#rm complete/*/*.1

#---------------------------------------------------------------------------------------------------
#4) Unzip all the .tgz files for the draft genomes
#---------------------------------------------------------------------------------------------------

#tar is stupid. It can't extract multiple files that match wildcard (e.g. *.tgz)
#	It also extracts to your WORKING dir. So have to cd every time
for dir in draft/* ; do
	cd $dir
	echo "working on $dir"
    tar -xzf *.ffn.tgz
    tar -xzf *.faa.tgz
    tar -xzf *.ptt.tgz
    tar -xzf *.frn.tgz
	cd $WORKING_DIR
done

#---------------------------------------------------------------------------------------------------
#5)Cat together contigs for draft genomes
#---------------------------------------------------------------------------------------------------

#in each dir, list the genome dirs and cd to cat all the .ffn in those dirs
for d in draft/*; do
	echo "working on: $d"
	cd $d
	#get rid of any existing leftover all.ffn otherwise you get stuck in an infinite loop of trying to cat it to itself
	if [ -e all.ffn ]; then
		rm all.ffn
	fi
	cat *.ffn > all.ffn
	cd $WORKING_DIR
done


# Get all complete genomes and all draft (bac and arc)
# Make one all_bac.ffn file
cat complete/*/*.ffn draft/*/all.ffn > all_bac.ffn

#---------------------------------------------------------------------------------------------------
# Get lookup of fasta IDs with accessions and taxid (use for taxonomic lineage lookup)
#---------------------------------------------------------------------------------------------------

ACC_FILE="all_bac.ffn_accession_lookup.txt"
TAX_FILE="all_bac.ffn_tax_lookup.txt"

# This script expects you have /complete and /draft in your working dir and will read through these
$BIN/add_accession_length.pl > $ACC_FILE

# Output:
#seqID	length	accession	taxID
#>gi|326802614|ref|NC_015278.1|:1064335-1064811 Aerococcus urinae ACS-120-V-Col10a chromosome, complete genome	477	NC_015278.1	866775


#Check that everything is there
#grep -c "^>" all_bac.ffn_lookup.txt all_bac.ffn 
#bac_ffn_lookup.txt:500994
#all_bac.ffn:500994

#exit if not the same count

#---------------------------------------------------------------------------------------------------
# Get the taxonomy information
#---------------------------------------------------------------------------------------------------

$BIN/get_taxonomy.pl $ACC_FILE 2> temp.txt > $TAX_FILE

rm temp.txt

#---------------------------------------------------------------------------------------------------
# Set up for SEED annotation
#---------------------------------------------------------------------------------------------------
# Get all the faa seqs
# cat has a finite limit so have to cat within each draft dir before cat-ing all the .faa files

for d in draft/*; do
	echo "working on: $d"
	cd $d
	if [ -e all.faa ]; then
		rm all.faa
	fi
	cat *.faa > all.faa
	cd $WORKING_DIR
done

cat complete/*/*.faa draft/*/all.faa > all_bac.faa




#---------------------------------------------------------------------------------------------------
# List of Perl scripts required
#---------------------------------------------------------------------------------------------------
#wget_ncbi_genomes.pl
#add_accession_length.pl
#get_taxonomy.pl

