#22Sept2015
# Jean Macklaim
# based on code from GG

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


#---------------------------------------------------------------------------------------------------
# Filtering #

# discard feature if it is a zero in half or more of the samples
cutoff = .5
d.1 <- data.frame(d[which(apply(d, 1, function(x){length(which(x != 0))/length(x)}) > cutoff),])

#Remove features with < 500 total counts (row sum < 500)
count = 500
d.0 <- data.frame(d.1[which(apply(d.1, 1, function(x){sum(x)}) > count),])

#---------------------------------------------------------------------------------------------------
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

