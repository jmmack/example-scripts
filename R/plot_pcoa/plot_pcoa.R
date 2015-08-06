#Based on already calculated UniFrac distances
#14-Nov-2014

R
setwd("/Groups/LRGC/kyle/plots/PCoA")

dd <- read.table("/Groups/LRGC/kyle/analysis_secondrun/qiime/all/weighted_unifrac_pc.txt", header=T, sep="\t", comment.char="", check.names=FALSE, stringsAsFactors=FALSE, row.names=1)

# be careful: last 2 rows are information about the PCoA
# Components are numbered columns after the metadata

#get data columns
d<-dd[1:(nrow(dd)-2),]

#get the %var
pc<-dd[nrow(dd),]

#get axes
maxc1<-max(d[,1])
minc1<-min(d[,1])
maxc2<-max(d[,2])
minc2<-min(d[,2])
maxc3<-max(d[,3])
minc3<-min(d[,3])

#get the coloring
p<-d[grep("_P", rownames(d)),]
c<-d[grep("_C", rownames(d)),]

t1<-d[grep("_01", rownames(d)),]
t2<-d[grep("_02", rownames(d)),]
t3<-d[grep("_03", rownames(d)),]
t4<-d[grep("_04", rownames(d)),]
t5<-d[grep("_05", rownames(d)),]

pc1<-round(pc[1], digits=2)
pc2<-round(pc[2], digits=2)
pc3<-round(pc[3], digits=2)

#test plots
#plot(d[,1], d[,2],pch=19, col="gray")
#plot(d[,3], d[,2],pch=19, col="gray")

pdf("test.pdf", height=8, width=10)
plot(d[,1], d[,3],pch=19, col="gray")
dev.off()

#plot 
pdf("UniFrac_PCoA.pdf", height=6, width=8)
par(mfrow=c(2,3), mar=c(3,3,0.5,0.5), oma=c(0,0,0,7), xpd=TRUE)
#color by study
plot(p[,1], p[,2],pch=19, col=rgb(1,0,0,0.5), xlim=c(minc1, maxc1), ylim=c(minc2, maxc2), xaxt="n", yaxt="n", xlab="", ylab="")
points(c[,1], c[,2],pch=19, col=rgb(0,0,1,0.5))
mtext(paste("PC1 (", pc1, "%)", sep=""), side=1, line=1)
mtext(paste("PC2 (", pc2, "%)", sep=""), side=2, line=1)

plot(p[,1], p[,3],pch=19, col=rgb(1,0,0,0.5), xlim=c(minc1, maxc1), ylim=c(minc2, maxc2), xaxt="n", yaxt="n", xlab="", ylab="")
points(c[,1], c[,3],pch=19, col=rgb(0,0,1,0.5))
mtext(paste("PC1 (", pc1, "%)", sep=""), side=1, line=1)
mtext(paste("PC3 (", pc3, "%)", sep=""), side=2, line=1)

plot(p[,3], p[,2],pch=19, col=rgb(1,0,0,0.5), xlim=c(minc3, maxc3), ylim=c(minc2, maxc2), xaxt="n", yaxt="n", xlab="", ylab="")
points(c[,3], c[,2],pch=19, col=rgb(0,0,1,0.5))
mtext(paste("PC3 (", pc3, "%)", sep=""), side=1, line=1)
mtext(paste("PC2 (", pc2, "%)", sep=""), side=2, line=1)

legend("right", inset=c(-0.45,0), title="Group", legend=c("Probiotic", "Control"), fill=c(rgb(1,0,0,0.5), rgb(0,0,1,0.5)), xpd=NA)

#color by tp
tcol=c(rgb(1,0,0,0.5), rgb(0,1,0,0.5), rgb(0,0,1,0.5), rgb(1,0,1,0.5), rgb(0,1,1,0.5))

plot(t1[,1], t1[,2],pch=19, col=tcol[1], xlim=c(minc1, maxc1), ylim=c(minc2, maxc2), xaxt="n", yaxt="n", xlab="", ylab="")
points(t2[,1], t2[,2],pch=19, col=tcol[2])
points(t3[,1], t3[,2],pch=19, col=tcol[3])
points(t4[,1], t4[,2],pch=19, col=tcol[4])
points(t5[,1], t5[,2],pch=19, col=tcol[5])
mtext(paste("PC1 (", pc1, "%)", sep=""), side=1, line=1)
mtext(paste("PC2 (", pc2, "%)", sep=""), side=2, line=1)

plot(t1[,1], t1[,3],pch=19, col=tcol[1], xlim=c(minc1, maxc1), ylim=c(minc2, maxc2), xaxt="n", yaxt="n", xlab="", ylab="")
points(t2[,1], t2[,3],pch=19, col=tcol[2])
points(t3[,1], t3[,3],pch=19, col=tcol[3])
points(t4[,1], t4[,3],pch=19, col=tcol[4])
points(t5[,1], t5[,3],pch=19, col=tcol[5])
mtext(paste("PC1 (", pc1, "%)", sep=""), side=1, line=1)
mtext(paste("PC3 (", pc3, "%)", sep=""), side=2, line=1)

plot(t1[,3], t1[,2],pch=19, col=tcol[1], xlim=c(minc3, maxc3), ylim=c(minc2, maxc2), xaxt="n", yaxt="n", xlab="", ylab="")
points(t2[,3], t2[,2],pch=19, col=tcol[2])
points(t3[,3], t3[,2],pch=19, col=tcol[3])
points(t4[,3], t4[,2],pch=19, col=tcol[4])
points(t5[,3], t5[,2],pch=19, col=tcol[5])
mtext(paste("PC3 (", pc3, "%)", sep=""), side=1, line=1)
mtext(paste("PC2 (", pc2, "%)", sep=""), side=2, line=1)

legend("right", inset=c(-0.4,0), title="Time Point", legend=c("t1", "t2", "t3", "t4", "t5"), fill=tcol, xpd=NA)

dev.off()

#--------------------------------------------------------------------------------
#--------------------------------------------------------------------------------
#--------------------------------------------------------------------------------
#--------------------------------------------------------------------------------
 
#These are example scripts from Brazil:
