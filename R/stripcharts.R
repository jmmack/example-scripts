# Multiple stripcharts per plot:
http://www.programiz.com/r-programming/strip-chart

# e.g.
meta<-read.table("/Volumes/iners/AL_biologicals/16S_Mar2016/metadata.txt", sep="\t", header=T, row.names=1, check.names=F)
tmeta<-t(meta)
#So samples are columns

#column names
gr1<-c("F1G", "F2G", "F4B", "F2B", "F1B", "F4G", "F5B", "F7G", "F7B")
gr2<-c("F12G", "F13B", "F13G", "F12B", "F11G", "F10G", "F11B")
gr3<-c("F3G", "F9G", "F10B", "F5G", "F3B", "F8G", "F8B", "F9B")

#for each row, plot per group
#Make a LIST (in x) to be able to plot multiple strips per plot

pdf("meta_stripchart_by_row.pdf")
for (i in 1:nrow(tmeta)){
	x<-list("l1"<-tmeta[i,gr1], "l2"<-tmeta[i,gr2], "l3"<-tmeta[i,gr3])
	stripchart(x, method="jitter", vertical="T", pch=16)
	title(main=rownames(tmeta)[i])
}
dev.off()
