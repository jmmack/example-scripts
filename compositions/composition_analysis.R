#22Sept2015
# Jean Macklaim
# based on code from GG
# Samples must be ROWS, so will have to transpose if you are using a QIIME-like OTU table

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
# samples must be by rows so use t()

d.bf <- cmultRepl(t(d.0), label=0, method="CZM")


#transform data to CLR
# the apply function rotates the data when by row, so turn it back to samples by row

d.n0.clr <- t(apply(d.bf, 1, function(x){log2(x) - mean(log2(x))}))


# generate the PCA object
pcx <- prcomp(d.n0.clr)


#Jean: set this up to color the biplots
coloredBiplot(pcx,col=rgb(0,0,0,0.3),cex=c(0.8,0.4), xlabs.col=conds$cond, var.axes=F, arrow.len=0.05)



#---------------------------------
# Ignore this down



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

