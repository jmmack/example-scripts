# Sum everything by a particular column (e.g. KO numbers)


d<-read.table("predicted_metagenome.biom.txt", sep="\t", quote="", row.names=1, check.names=F, header=T, comment.char="")
#KOs are in first column

d.agg <- aggregate(d, by=list(rownames(d)), FUN=sum)
write.table(d.agg, file="KO_sum.txt", sep="\t", quote=FALSE, row.names=F)
