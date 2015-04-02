#Example to run ALDEx2
#By Jean M Macklaim

#ALDEx2 is a Bioconductor package available here:
#http://www.bioconductor.org/packages/release/bioc/html/ALDEx2.html

# Please see the Bioconductor page for the manual and install instructions

library(ALDEx2)

#read in a table of counts data
d<-read.table("input_table.txt", sep="\t", quote="", check.names=F, header=T, row.names=1)

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
