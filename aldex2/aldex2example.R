#Example to run ALDEx2
#By Jean M Macklaim

#ALDEx2 is a Bioconductor package available here:
#http://www.bioconductor.org/packages/release/bioc/html/ALDEx2.html

# Please see the Bioconductor page for the manual and install instructions

library(ALDEx2)

#read in a table of counts data
d<-read.table("input_table.txt", sep="\t", quote="", check.names=F, header=T, row.names=1, comment.char="")

#alternatively, you can load the example dataset "selex"
#data(selex)

#subsetting a table based on sample names (column names)
C<-c("010B", "001B", "009B")
I<-c("002B", "004B", "006B")

#this will retain the same order as the lists above
aldex.in<-d[,c(C, I)]

#Make a vector of conditions. This must be in the same order and the same number as the columns (samples) of the input table (aldex.in)
conds<-c(rep("C", length(C)), rep("I", length(I)))

#get the clr values
#this is the main ALDEx function for all downstream analyses
#mc.samples=128 is often sufficient
x <- aldex.clr(aldex.in, mc.samples=128, verbose=TRUE)

#perform t-test (both Welches and Wilcoxon, plus a Benjamini-Hochberg multiple test correction)
x.tt <- aldex.ttest(x, conds, paired.test=FALSE)

#estimate effect size and the within and between condition values
#include indiv. samples or not
x.effect <- aldex.effect(x, conds, include.sample.summary=TRUE, verbose=TRUE)


#merge the data
x.all <- data.frame(x.tt, x.effect)

#write a .txt with your results
write.table(x.all, file="aldex_ttest.txt", sep="\t", quote=F, col.names=NA)

#See plots
pdf("MA.pdf")
aldex.plot(x.all, type="MA", test="welch")
dev.off()

pdf("MW.pdf")
aldex.plot(x.all, type="MW", test="welch")
dev.off()

#-----------------------------------------------------------------------------------------------
#more advanced

#get features passing significance

sig <- which(x.all$we.eBH < 0.05)

#only significant points in the positive direction
psig <- which(x.all$we.eBH < 0.05 & x.all$diff.btw > 0)

#plot diff btwn vs diff within
#plot significant points in a different color
#add the effect=1 and -1 lines
plot(x.all$diff.win, x.all$diff.btw, pch=19, cex=0.3, col=rgb(0,0,0,0.3),
 xlab="Difference within", ylab="Difference between")
points(x.all$diff.win[sig], x.all$diff.btw[sig], pch=19,
 cex=0.5, col=rgb(0,0,1,0.5))
abline(0,1,lty=2)
abline(0,-1,lty=2)

#add labels to points on the plot
text(x.all$diff.win, x.all$diff.btw, labels=row.names(x.all), cex= 0.7, pos=3)

#only the positive significant points
text(x.all$diff.win[psig], x.all$diff.btw[psig], labels=row.names(x.all[psig,]), cex= 0.7, pos=3)

#Add a label to a single (named) point
text(x.all["sample1",]$diff.win, x.all["sample1",]$diff.btw, labels=row.names(x.all["sample1",]), cex= 0.7, pos=3, col="red")

