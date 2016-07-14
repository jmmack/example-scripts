# 5Apr2016 - JM
# This is a general example for reading a table and making compositional biplots in R
--------------------------------------------------------------------------------------------
#Set your working directory (this is where your output will go)
setwd("/Volumes/longlunch/seq/LRGC/your_name/your_compositions_directory")

#load the packages (you will have to install these if you do not have them already)
library(compositions)
library(zCompositions)

--------------------------------------------------------------------------------------------
## Read in your counts table

# Samples are columns, and features (OTUs, genera, genes) are rows
# You may need optional parameters: header=T, check.names=F, comment.char="", skip=1
rr <- read.table("/path/to/counts_table.txt", header=T, sep= "\t", stringsAsFactors=F, quote = "", check.names=F, row.names=1)

#check that your table looks OK
dim(rr) #is this the right number of samples and features?
colnames(rr)
rownames(rr)
head(rr)

--------------------------------------------------------------------------------------------
## Getting the samples you want to compare

# Your table must contain numeric data only
# You can remove non-numeric columns (e.g. your taxonomy column), or extract the columns you want to compare based on a list
#Example removing taxonomy column:
r<-rr[,1-ncol(rr)-1] #This is assuming your tacxonomy column is the last column

# Example using a list to pull out columns of interest
# Vector of column names to keep for analysis
BV1<-c("006A", "009A", "010A", "012A")
BV2<-c("008A", "013A", "016B", "012B", "014B", "017B", "018B", "27S")

#combine the samples together into one table
r<-rr[,c(BV1, BV2)]

--------------------------------------------------------------------------------------------
## Filtering by read counts

# You may need to filter your data to remove features (OTUs) that are low abundance
# See here for more examples
https://github.com/mmacklai/16S/blob/master/manipulating_counts_table.md

## NOTE: If you remove ANY samples from your table, or extract a subset of samples, you MUST re-filter your OTUs (see link above for examples)

#Example: remove features with mean read count <=1
count <- 1
r.1 <- data.frame(r[which(apply(r, 1, function(x){mean(x)}) > count),], check.names=F)

--------------------------------------------------------------------------------------------
## Compositional analysis

#replace zeros with estimate
#samples must be ROWS (so transpose)
r.czm <- cmultRepl(t(r.1),  label=0, method="CZM")

#calculate the CLR
#need to transpose because of cmultRepl
r.clr <- t(apply(r.czm, 1, function(x){log(x) - mean(log(x))}))

#Need this to calculate %variance explained
r.mvar <- mvar(r.clr)

--------------------------------------------------------------------------------------------
## Make a compositional biplot based on the feature varaince

#calculate principal components
#features are COLUMNS
r.pcx <- prcomp(r.clr)
#--- Side Bar ---#
# To see your "Scree plot"
#   plot(d.pcx)

# You can sum up the variances for all features per sample (variance across all components of the PCA)
# IN THEORY: samples with a summed variance closer to zero are more "typical" or "average" of the group
# and samples with very large variances are potential outliers
#   rowSums(d.pcx$x)
# Note: these summed variances will differe if you add or remove samples

# Make the number of points equal to the number of features (for feature labels)
#use: "o" or "."
points <- c(rep(".", length(dimnames(r.pcx$rotation)[[1]])))

# Sample names will be used as plot labels, or you can use symbols:
#samples <- c(rep("o", length(dimnames(r.pcx$x)[[1]])))

#color and text size for labels and points (vector of 2)
# First value in each case is for samples, and the second value for eatures
col=c("black",rgb(1,0,0,0.2))
c=c(0.8, 2)

#Change the name of your plot here
pdf("test.pdf")
biplot(r.pcx, cex=c, col=col, var.axes=F,
    xlab=paste("PC1: ", round(sum(r.pcx$sdev[1]^2)/r.mvar, 3)),
    ylab=paste("PC2: ", round(sum(r.pcx$sdev[2]^2)/r.mvar, 3)),
    scale=0, ylabs=points
)
dev.off()

# You should also consider making a dendrogram of samples:
https://github.com/mmacklai/example-scripts/blob/master/R/heatmap_dendrograms.R

hc <- hclust(dist(d.clr))
plot(hc)
#line up labels
plot(hc, hang=-1)


