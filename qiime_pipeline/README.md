Basic QIIME workflow  
Last update: Nov 17, 2015  
Original: /Volumes/iners/torrent_V6_pipeline/qiime_pipeline/qiime_workflow_JM.txt

---
Reference to all QIIME scripts:  
http://qiime.org/scripts/

For biom format see:  
http://biom-format.org/documentation/biom_format.html

---
## Input files

Minimum for UniFrac analysis:
1. OTU table
2. Metadata table
3. OTU SEED sequences (FASTA format)

EXAMPLE DATA are in the `test_data` directory.  
You should be able to run these example files through this workflow

#### File Formats:

1) OTU table:

	# Comment header here
	#OTU ID	47bcont	35bcont	21bcont	53bcont	61bcont	taxonomy
	0	29552	1814	19424	8617	30149	Bacteria;Firmicutes;Bacilli;Lactobacillales;Lactobacillaceae;Lactobacillus;iners
	1	3665	1081	2428	5742	1605	Bacteria;Firmicutes;Bacilli;Lactobacillales;Lactobacillaceae;Lactobacillus;crispatus
	2	867	6379	1926	6447	1418	2407	Bacteria;Actinobacteria;Actinobacteria;Bifidobacteriales;Bifidobacteriaceae;Gardnerella;vaginalis

- First line is a comment line (describe any information you want about the table)
- Second line starts with "#OTU ID" and each tab-delimited column is a sample ID
- Each subsequent line is the name of your OTU and then the number of reads per sample
- Final column in your table can be named "taxonomy" and contains a semicolon separated hierarchy of taxonomy (based on RDP format)
	This column is OPTIONAL but recommended (otherwise you will only have OTU numbers on plots and no taxonomic information)

2) Metadata table
- A tab-delimited table of metadata describing your samples (the columns will be used in Kingviewer to color/select your sample points)

		#SampleID	time	study	probio	age	a_dis	a_whiff	a_ph	a_clue	n_status
		47bcont	0	b_cont	NA	41	n	n	0	ND	n
		35bcont	0	b_cont	NA	36	n	n	0	ND	n
		21bcont	0	b_cont	NA	45	n	n	0	ND	n

- First column starts with "#SampleID" and lists the IDs exactly matching the IDs in your OTU table \(see 1\)
- Each subsequent column can have any information you want to be able to view (age, group, time point, etc)


3) OTU SEED sequences (FASTA format)
- Typically named `OTU_seed_seqs.fa`

		>lcl|8|num|3965605|OTU|0
		AGGTCTTGACATCCATAGCCAGTCTAAGAGATTAGATGTTCCCTTCGGGGACTATGAGACAGGTGGTGCATGGCT
		>lcl|1|num|2183833|OTU|1
		AGGTCTTGACATCTAGTGCCATTTGTAGAGATACAAAGTTCCCTTCGGGGACGCTAAGACAGGTGGTGCATGGCT



---
## Now for the analyses within QIIME
- To begin macqiime, type `macqiime` in your terminal on cjelli

#### General workflow:
1. Convert OTU table to .biom format
2. Summarize the dataset
3. Summarize the taxonomy and plot
4. UniFrac beta-diversity analysis
  1. Make multiple sequence alignment and phylogenetic tree of OTUs
  2. Run UniFrac analysis and produce beta-diversity plots
5. Biplots


##### 1) Convert OTU table to .biom format in QIIME  
_IF YOUR OTUs ARE IN COLUMNS RATHER THAN ROWS (e.g. GG's output): transpose the table using R script or Excel
`R CMD BATCH $BIN/OTU_to_QIIME.R OTU_to_QIIME.out`_

For QIIME 1.9:
`biom convert -i otu_table_psn_v35.txt -o otu_table.biom --to-hdf5 --table-type="OTU table"`

Old versions of QIIME may use:
`biom convert -i td_OTU_tag_mapped_lineage.txt -o otu_table.biom --table-type="otu table" -t dense --process-obs-metadata=taxonomy`

---
#### NOTE
> In QIIME 1.9 There is one convenient script (`core_diversity_analyses.py`) that performs most of the analyses below automatically  
> You need to have your .biom OTU table, your mapping (metadata) file, and an OTU tree
>
> http://qiime.org/scripts/core_diversity_analyses.html  
`core_diversity_analyses.py` will automatically run:  
`alpha_rarefaction.py`, `beta_diversity_through_plots.py`, `summarize_taxa_through_plots.py`, `make_distance_boxplots.py`, `compare_alpha_diversity.py`, `group_significance.py`

---

 >...Otherwise, here are the individual scripts:

##### 2) Summarize the dataset (OTU table)
###### Read counts per sample
`biom summarize-table -i otu_table.biom -o stats_otu_table.txt`

######Number of OTUs per sample
`biom summarize-table -i otu_table.biom --qualitative -o stats_otu_table_qual.txt`


**LOOK AT THESE FILES ^^^^^**  
**_Seriously_**  
**LOOK** at them  
Make sure your data are OK before continuing. **If you do ANY filtering, or manipulation of your OTU table, RUN THESE STATS AGAIN _AND LOOK AT THE FILE_**


##### 3) Summarize and plot the taxonomy  
This will sum your counts per taxonomic level (2 is generally phylum, down to 7 which is generally species)

This gives tables of relative values:  
`summarize_taxa.py -i otu_table.biom -L 2,3,4,5,6,7 -o taxa_summary`  
This gives tables of absolute read counts. Use these for plotting barplots in R:  
`summarize_taxa.py -a -i otu_table.biom -L 2,3,4,5,6,7 -o taxa_summary_absolute/`

Use the above summarized tables to plot QIIME-style barplots
`plot_taxa_summary.py -i taxa_summary/otu_table_L1.txt,taxa_summary/otu_table_L2.txt,taxa_summary/otu_table_L3.txt,taxa_summary/otu_table_L4.txt,taxa_summary/otu_table_L5.txt,taxa_summary/otu_table_L6.txt,taxa_summary/otu_table_L7.txt -o taxa_summary/plots`


##### 4) UniFrac beta-diversity analysis
###### i) OTU multiple sequence alignment (for UniFrac analysis)

- The tips/sequences MUST have the same names as the OTU IDs in your OTU table (see 1)  
	_e.g sequences have to be named OTU_0 if that is the column header in your OTU table_
- Any non-matching IDs in the tree OR the OTU table will be IGNORED by QIIME
- For V6: MUSCLE recommended over any structure/reference-based alignments
````
mkdir muscle
muscle -in ../../workflow_out/all_seed_OTUs.fa -out muscle/all_seed_OTUs_bad.mfa
````
- Fix formatting for OTU names (should be number only)
````
awk '/^>/{gsub(/lcl\|[0-9]+\|num\|[0-9]+\|OTU\|/, "")}; 1' muscle/all_seed_OTUs_bad.mfa > muscle/all_seed_OTUs.mfa`
rm muscle/all_seed_OTUs_bad.mfa
````

###### i) Make a phylogenetic tree based on OTU sequence alignment
- Default in QIIME is FastTree

`make_phylogeny.py -i muscle/all_seed_OTUs.mfa -o muscle/fasttree_all_seed_OTUs.tre`

###### ii) Run UniFrac analysis and produce beta-diversity plots

Basic command:

`beta_diversity_through_plots.py -i otu_table.biom -m metadata_table.txt -o bdiv_all -t muscle/fasttree_all_seed_OTUs.tre`

`-i` is the OTU table  
`-m` is the metadata table  
`-o` is your output directory (I like to name it with the value I rarefied to)  
`-t` is the Newick tree file  
`-e` is the number of reads to rarefy all samples too

For more info on the scripts being run:  
http://qiime.org/scripts/beta_diversity_through_plots.html

---
##### 5) Make biplots showing correlations between PCoA clustering and abundant taxa

`make_3d_plots.py -i bdiv_all/weighted_unifrac_pc.txt -m metadata_table.txt -t bdiv_all/taxa_summary/otu_table_L6.txt --n_taxa_keep 10 -o bdiv_all/3d_biplot_L6_weighted`

---
## Other useful scripts

##### Filter your OTU table by sample or metadata

1. filter samples by total read counts (at least 150 counts per sample)  
`filter_samples_from_otu_table.py -i otu_table.biom -o otu_table_150.biom -n 150`

2. filter OTUs by total count (at least 100 read counts per OTU)  
`filter_otus_from_otu_table.py -i otu_table_150.biom -o otu_table_r150_o100.biom -n 100`

3. Check the stats  
`biom summarize-table -i otu_table_r150_o100.biom | head -n 12`

4. Filter the OTU fasta to match  
`filter_fasta.py -f rep_set_v35.fna -b otu_table_r150_o100.biom -o rep_set_v35_r150_o100.fna`


#### Also, you can go back and filter a distance matrix

````
mkdir bdiv_all/filter
filter_distance_matrix.py -i bdiv_all/weighted_unifrac_dm.txt -o bdiv_all/filter/weighted_unifrac_dm_time0.txt -m metadata_table.txt -s "time:0"
````

- Compare 3D PCoA plots (e.g. if you have a sample set before and after treatment) `compare_3d_plots.py`
http://qiime.org/scripts/compare_3d_plots.html
  - Make an edges file to connect sample time-points

- Compare UniFrac distances
`make_distance_boxplots.py`
http://qiime.org/scripts/make_distance_boxplots.html

http://qiime.org/tutorials/creating_distance_comparison_plots.html

- Shannon's diversity
`alpha_diversity.py`
http://qiime.org/scripts/alpha_diversity.html

  - Why use Shannon's diversity compared to Chao1, etc.  
_Robust estimation of microbial diversity in theory and in practice
Bart Haegeman, Jérôme Hamelin, John Moriarty, Peter Neal, Jonathan Dushoff, Joshua S. Weitz_
http://arxiv.org/abs/1302.3753


- Make a UPGMA sample tree (another way to view the PCoA clusters)  
http://qiime.org/scripts/upgma_cluster.html

`upgma_cluster.py -i weighted_unifrac_dm.txt -o weighted_cluster.tre`

- Convert a biom table back to tab-delimited
`convert_biom.py -i otu_table.biom -o otu_table.txt -b --header_key='taxonomy"`

### Beta diversity manually, step-by-step
_This is only necessary if_ `beta_diversity_though_plots.py` _doesn't work, or if you want to make a new distance matrix or coordinates file_


1) Make UniFrac distance Matrix  
`beta_diversity.py -i otu_table.biom -o beta_div -t file.tre`

_This output goes to the next step_

2) Make the principal coordinates plot  
`principal_coordinates.py -i weighted_unifrac_dm.txt -o weighted_unifrac_pc.txt`


3) Make 3D PCoA plots for KING VIEWER  
`make_3d_plots.py -i bdiv_all/weighted_unifrac_pc.txt -m analysis_tumor/metadata_table_resorted.txt -o bdiv_all/`


---
### Other notes

FigTree is useful to view phylogenies:  
http://tree.bio.ed.ac.uk/software/figtree/

You may need to install KingViewer to see kinimage files (3D PCoA plots)  
http://kinemage.biochem.duke.edu/software/king.php
