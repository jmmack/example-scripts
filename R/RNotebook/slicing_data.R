# which()

(After slicing out a data, match up to your dataframe)
# See !duplicated example below
#Example to find samples with >60% lactobacillus:
#Check for >60% lacto samples

n<-which(yy[1,1:124]>0.6)
write.table(n, "n.txt")

# duplicated() or !duplicated() to find unique entries

Gives indices of duplicated (or unique) elements. Returns TRUE/FLASE
which() will return the indices: which(!duplicated(d$col))
Then use d[which(!duplicated(d$col)),] to pull the actual duplicated rows (using the index lookup)

which(duplicated(d$ids))

Example to get unique subsys4+refseq:
> d<-read.table("readcounts_subsyshier.txt", header = TRUE, sep= "\t", stringsAsFactors=F, quote = "")
> diffreads <- d[which(!duplicated(paste(d$subsys4,d$refseq_id,sep = ""))),]

# Get rows (or columns) in data frame matching a character string

bv<-td[grep("bbv", rownames(td)),]

# using OR
bv<-td[grep(‘(bbv|bvvc)', rownames(td)),]

#Get row numbers for features
psig <- which(x.all$we.eBH < 0.05 & x.all$diff.btw > 0)
plot(x.all$diff.win[sig], x.all$diff.btw[sig], pch=19)
