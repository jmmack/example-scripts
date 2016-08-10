#14Apr2016 - JM
# /Volumes/iners/AL_biologicals/16S_Mar2016/analysis/CoDa/aldex2/aldex2_all.R

# Plot biplot for each farm individually

library(ALDEx2)

setwd("/Volumes/iners/AL_biologicals/16S_Mar2016/analysis/CoDa/aldex2")

dd<-read.table("/Volumes/iners/AL_biologicals/16S_Mar2016/workflow_out/taxonomy_AL_MAR2016/td_OTU_tag_mapped_lineage.txt", sep="\t", row.names=1, header=T, check.names=F, skip=1, comment.char="")
tax<-dd$taxonomy
de<-dd[,1:ncol(dd)-1]


#need ro remove controls, and the F3-GT samples
excl<-c("55_1", "55_2", "7_1", "7_2", "BE_1", "BE_2", "BE_3", "BE_4", "BLANK_1", "BLANK_2", "BLANK_3", "BLANK_4", "BLANK_5", "BLANK_6", "CWB_1", "CWB_2", "CWB_3", "CWB_4", "EB_1", "EB_2", "EB_3", "EB_4", "PCR_H2O_1", "PCR_H2O_2", "PCR_H2O_3", "PCR_H2O_4", "WB_1", "WB_2", "WB_3", "WB_4")
gt<-c("F3-GT1", "F3-GT2", "F3-GT3", "F3-GT4", "F3-GT5", "F3-GT6")

df <- de[, !names(de) %in% c(excl,gt)]

#put in alphabetical order
d <- df[,order(colnames(df))]

#remove OTUs with mean counts <1
count <- 1
d.1 <- data.frame(d[which(apply(d, 1, function(x){mean(x)}) > count),], check.names=F)
#This removed nothing
#mean count <10 removed one OTU

#ALDEx needs a DATAFRAME not a MATRIX

#set the taxonomy names as rownames
otu<-rownames(d.1)
rownames(d.1)<-paste(otu, tax, sep="_")


#they all have 6 good and 6 bad
conds<-c(rep("B", ncol(d.1)/2), rep("G", ncol(d.1)/2))

x <- aldex.clr(d.1, mc.samples=128, verbose=TRUE)

#x.tt <- aldex.ttest(x, conds, paired.test=FALSE)

x.effect <- aldex.effect(x, conds, include.sample.summary=TRUE, verbose=TRUE)

#x.all <- data.frame(x.tt, x.effect)

#write a .txt with your results
write.table(x.effect, file="aldex_rel_abund_all.txt", sep="\t", quote=F, col.names=NA)

###---
# Dendrogram

e<-x.effect[,grep("sample", colnames(x.effect))]
cnames<-gsub("rab.sample.", "", colnames(e))
colnames(e)<-cnames
et<-t(e)

hc <- hclust(dist(et))
#hc <- hclust(dist(et, method="manhattan"), method="average")

pdf("aldex_dendrogram.pdf", width=20)
plot(hc, cex=0.6, hang=-1)
dev.off()


#------------------------------------
# For comparison: dendrogram of czm method

library(compositions)
library(zCompositions)

d.czm <- cmultRepl(t(d.1),  label=0, method="CZM")
#No. corrected values:  1 ??????
d.clr <- t(apply(d.czm, 1, function(x){log(x) - mean(log(x))}))

hc2 <- hclust(dist(d.clr))
#hc2 <- hclust(dist(d.clr, method="manhattan"), method="average")
pdf("czm_dendrogram.pdf", width=20)
plot(hc2, cex=0.6, hang=-1)
dev.off()
