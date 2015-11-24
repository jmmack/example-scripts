#22Sept2015
#Jean Macklaim
#ReidLacto:~/Documents/Agrajag/composition_analysis_general.R

#---------------------------------------------------------------------------------------------------

d<-read.table("test.txt", sep="\t", row.names=1)
#need to remove all the odd columns

# I know that paste put the files together in alphanumeric order
col<-c("G2","G3","G6","G9","GT10","GT1","GT8","GT9","H10","H1","H6","H9")
colnames(d)<-col

write.table(d, "all_counts_q0.txt", sep="\t", quote=F, col.names=NA)

#check total counts
colSums(d)

# this is with mapping quality > 10
# Total readcounts per sample (mapped to features)
> colSums(d2)
     G2      G3      G6      G9    GT10     GT1     GT8     GT9     H10      H1
3859780 5769824 4225950 4689730 6022734 5288911 7237567 2874351 3389254 3489746
     H6      H9
2736007 1526492

#This is mapping quality 0
> colSums(d)
      G2       G3       G6       G9     GT10      GT1      GT8      GT9
 9402803 12233088  9934407 10259641 12814791 11951938 13856337  7101273
     H10       H1       H6       H9
 8521174  9202321  8411447  7195064
#--------------------------------------------------------------------------------------------------
# Install packages

options(download.file.method="libcurl")
install.packages("compositions")
install.packages("zCompositions")

#--------------------------------------------------------------------------------------------------
library(compositions)
library(zCompositions)

#read table if necessary
d <- read.table("all_counts.txt", header=T, row.names=1)


# discard if the feature/gene is a zero in half or more of the samples
cutoff = 1-.5
d.0 <- data.frame(d[which(apply(d, 1, function(x){length(which(x == 0))/length(x)}) < cutoff),])

# from zCompositions
# replace 0 with a Bayesian estimate of 0
# this is proportions, to get counts use 'output="counts"'
d.bf <- cmultRepl(d.0, label=0, method="CZM")

# from compositions
# convert to a clr object with acomp, but it is an S3 object

bi <- acomp(d.bf)
pcx <- princomp(bi)

biplot(pcx, cex=c(0.2,0.6))				#standard plot
biplot(pcx, cex=c(0.2,0.6), scale=0)	#scale by variables instead of samples

# See what %varation is explained by each component
sum(pcx$sdev[1]^2)/mvar(bi)
sum(pcx$sdev[2]^2)/mvar(bi)
sum(pcx$sdev[3]^2)/mvar(bi)

#--------------------------------------------------------------------------------------------------
# Additional filtering

#discard featrues that have <500 total counts
d.0 <- data.frame(d.nt[which(apply(d, 1, sum) > 500),])

