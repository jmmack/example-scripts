#1Feb2016 JM
# Sum a counts table by taxonomic level (equivalent to QIIME's summarize_taxa.py function
# Original: /Groups/twntyfr/analysis_2016/heatmap_barplot/sum_taxa.R

d<-read.table("/Groups/twntyfr/analysis/merged_readcounts_taxonomy.txt", sep="\t", quote="", check.names=F, header=T, row.names=1, comment.char="")

##refseqIDfaa	refseqID	length	[sample IDs]	subsys4	common_taxonomy
#ID1faa	ID	500	[counts]	 GTP-binding protein EngB	Bacteria;Firmicutes;Bacilli;Lactobacillales;Lactobacillaceae;Lactobacillus

#get the taxonomy column
tax<-d$common_taxonomy

#just get the counts columns
dm<-d[,5:ncol(d)-2]

#this aggregates by the total taxonomy string
dm.agg <- aggregate(dm, by=list(tax), FUN=sum)

#split by each taxonomic level: splitting on ";"
split<-strsplit(as.vector(tax), ";")

#accessing the data, e.g.
#split[[1]] is the first row (refseq)
#split[[1]][1] is the first taxonomy level of the first row

#Sum all the reads by the 6th taxonomic level (separated by ;)
# in sapply, <"[", 6> will pull the 6th element
split6 <- sapply(strsplit(as.character(tax), ";"), "[", 6)

#6 is genus in this data set
dm.agg6 <- aggregate(dm, by=list(split6), FUN=sum)
