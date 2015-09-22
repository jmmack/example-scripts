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

