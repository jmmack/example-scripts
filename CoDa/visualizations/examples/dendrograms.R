#14Apr2016 - JM
# /Volumes/iners/AL_biologicals/16S_Mar2016/analysis/CoDa/dendrograms.R
# CAN source()

# Plot biplot for each farm individually

library(compositions)
library(zCompositions)

setwd("/Volumes/iners/AL_biologicals/16S_Mar2016/analysis/CoDa")

d<-read.table("/Volumes/iners/AL_biologicals/16S_Mar2016/workflow_out/taxonomy_AL_MAR2016/td_OTU_tag_mapped_lineage.txt", sep="\t", row.names=1, header=T, check.names=F, skip=1, comment.char="")

#-----
tax<-d$taxonomy

pdf("all_dendrograms.pdf")

for(i in 1:13){
	d.m<-as.matrix(d[,grep(paste("F",i,"-",sep=""), colnames(d))])
	otu<-rownames(d.m)
	rownames(d.m)<-paste(otu, tax, sep="_")

count = 1
d.0 <- data.frame(d.m[which(apply(d.m, 1, function(x){sum(x)}) > count),], check.names=F)

d.czm <- cmultRepl(t(d.0),  label=0, method="CZM")
#No. corrected values:  355

d.clr <- t(apply(d.czm, 1, function(x){log(x) - mean(log(x))}))


hc <- hclust(dist(d.clr))
plot(hc)


}
dev.off()
