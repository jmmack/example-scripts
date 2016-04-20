#14Apr2016 - JM
#/Volumes/iners/AL_biologicals/16S_Mar2016/analysis/CoDa/heatmap_biplot.R
# CAN source()

# Make a heatmap of OTUs based on clr values

library("gplots")
library(compositions)
library(zCompositions)

setwd("/Volumes/iners/AL_biologicals/16S_Mar2016/analysis/heatmap")

dd<-read.table("/Volumes/iners/AL_biologicals/16S_Mar2016/workflow_out/taxonomy_AL_MAR2016/td_OTU_tag_mapped_lineage.txt", sep="\t", quote="", check.names=F, header=T, row.names=1, comment.char="", skip=1)
d<-dd[,1:ncol(d)-1]

excl<-c("55_1", "55_2", "7_1", "7_2", "BE_1", "BE_2", "BE_3", "BE_4", "BLANK_1", "BLANK_2", "BLANK_3", "BLANK_4", "BLANK_5", "BLANK_6", "CWB_1", "CWB_2", "CWB_3", "CWB_4", "EB_1", "EB_2", "EB_3", "EB_4", "PCR_H2O_1", "PCR_H2O_2", "PCR_H2O_3", "PCR_H2O_4", "WB_1", "WB_2", "WB_3", "WB_4")

d <- d[, !names(d) %in% excl]


count <- 1
d.1 <- data.frame(d[which(apply(d, 1, function(x){mean(x)}) > count),], check.names=F)
#This removed nothing


#replace zeros with estimate
#samples must be ROWS (so transpose)
d.czm <- cmultRepl(t(d.1),  label=0, method="CZM")

#calculate the CLR
#need to transpose because of cmultRepl
d.clr <- t(apply(d.czm, 1, function(x){log(x) - mean(log(x))}))

#try average linkage clustering
av <- function(x) hclust(x, method="average")
man <- function(x) dist(x, method="manhattan")
# Based on visual inspection and experience, we probably want to stick with complete linkage and euclidean distance (both default)

pdf("subsys4_heatmap_av_man.pdf", width=20)
heatmap.2(t(d.clr), trace="none", col=rev(heat.colors(16)), dendrogram="column", labRow=NA, hclustfun=av, distfun=man)
dev.off()


# Let's make the total biplot too
d.mvar <- mvar(d.clr)
d.pcx <- prcomp(d.clr)

points <- c(rep(".", length(dimnames(d.pcx$rotation)[[1]])))

col=c("black",rgb(1,0,0,0.2))
c=c(0.8, 2)

pdf("biplot_total.pdf")
biplot(d.pcx, cex=c, col=col, var.axes=F,
    xlab=paste("PC1: ", round(sum(d.pcx$sdev[1]^2)/d.mvar, 3)),
    ylab=paste("PC2: ", round(sum(d.pcx$sdev[2]^2)/d.mvar, 3)),
    scale=0, ylabs=points
)
dev.off()

