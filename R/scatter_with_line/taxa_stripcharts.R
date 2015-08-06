setwd("/Groups/LRGC/kyle/JM/taxa_stripcharts")

d<-read.table("/Groups/LRGC/kyle/JM/mothur/taxonomy/taxa_summary_absolute/otu_table_L5_sorted_bygroup.txt", header=T, sep="\t", row.names=1, comment.char="", check.names=FALSE, stringsAsFactors=FALSE)
#Sum OTU counts for each column and get fraction values
y <- apply( d[,1:ncol(d)] , 2, function(x) { x / sum(x) } )

yp<-y[,grep("_P", colnames(y))]
yc<-y[,grep("_C", colnames(y))]

for (i in 1:nrow(y)){
pdf(paste(i, "_scaled.pdf", sep=""))
	plot(-1, xlim=c(0.5,5.5), xlab="", ylab="", xaxt="n", main=rownames(y)[i], ylim=c(0,max(y[i,])))#, ylim=c(0,1)
#ylim=c(min(y[i,]),max(y[i,]))
	mtext("Microbiota Fraction", side=2, line=2.5)
	axis(1, labels=c("Baseline", "4 hours", "24 hours", "7 days", "14 days"), at=c(1:5), las=1)

	for (j in 1:5){
	cdata<-yc[,grep(paste("_0", j, sep=""), colnames(yc))][i,]
	pdata<-yp[,grep(paste("_0", j, sep=""), colnames(yp))][i,]

		stripchart(pdata, method="jitter", jitter=0.15, pch=20, vertical=TRUE, at=j, add=TRUE, col=rgb(1,0,0,0.5))
		stripchart(cdata, method="jitter", jitter=0.15, pch=20, vertical=TRUE, at=j, add=TRUE, col=rgb(0,0,1,0.5))

		segments(j-0.2, median(c(pdata,cdata), na.rm=TRUE), j+0.2, median(c(pdata,cdata), na.rm=TRUE), lwd=3, lend="butt")

	}
dev.off()
}

#----------------------------------------------------
pdf("boxplot_test.pdf")
	boxplot(yp[1], use.cols = FALSE)
	boxplot(yp[1], use.cols = FALSE)
dev.off()
