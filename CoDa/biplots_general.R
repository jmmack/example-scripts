#23-Oct-2017 update

setwd("/Groups/twntyfr/analysis_2016/biplot")

library(compositions)
library(zCompositions)

#reads summed into subsys4 by Aitchison method
dd <- read.table("/Groups/twntyfr/analysis/aitchison/subsys4_mappedreads_aitchison_sum.txt", header=T, sep= "\t", stringsAsFactors=F, quote = "", check.names=F, row.names=1)

# Vector of column names to keep for analysis
BV1<-c("006A", "009A", "010A", "012A")
BV2<-c("008A", "013A", "016B", "012B", "014B", "017B", "018B", "27S")

d<-dd[,c(BV1, BV2)]

#remove refseqs with mean read count <=1
count <- 1
d.1 <- data.frame(d[which(apply(d, 1, function(x){mean(x)}) > count),], check.names=F)


#replace zeros with estimate
#samples must be ROWS (so transpose)
d.czm <- cmultRepl(t(d.1),  label=0, method="CZM")

#calculate the CLR
#need to transpose because of cmultRepl
d.clr <- t(apply(d.czm, 1, function(x){log(x) - mean(log(x))}))

#calculate principal components
#features are COLUMNS
d.pcx <- prcomp(d.clr)

# Sum the total variance
d.mvar <- sum(d.pcx$sdev^2)
# Calculate the PC1 and PC2 variance
PC1 <- paste("PC1: ", round(sum(d.pcx$sdev[1]^2)/d.mvar, 3))
PC2 <- paste("PC2: ", round(sum(d.pcx$sdev[2]^2)/d.mvar, 3))
# We are pasting together the component name and the variance to make an axes label

# Make the number of points equal to the number of features (for labels)
#use: "o" or "."
points <- c(rep(".", length(dimnames(d.pcx$rotation)[[1]])))

#color and text size for labels and points (vector of 2)
col=c("black",rgb(1,0,0,0.2))
c=c(0.8, 2)

pdf("test.pdf")
biplot(d.pcx, cex=c, col=col, var.axes=F,
    xlab=paste("PC1: ", round(sum(d.pcx$sdev[1]^2)/d.mvar, 3)),
    ylab=paste("PC2: ", round(sum(d.pcx$sdev[2]^2)/d.mvar, 3)),
    scale=0, ylabs=points
)
dev.off()
