#12-Nov-2014 - JM
# Stripchart plot for Yige's data
# Showing the paired Bray-Curtis distance for samples time point 1 vs tp2, tp1 vs tp3, and tp1 vs tp4
# (3 strips, 10 sets of samples/points per strip)

#--------------------------------------------------------------------------
# Input data

#This is a symmetrical matrix
d<-read.table("/Users/mmacklai/Downloads/Yige/bray_curtis_Urine_Oct_14_OTU_table.txt", header=T, sep="\t", row.names=1, comment.char="", check.names=FALSE, stringsAsFactors=FALSE)


#--------------------------------------------------------------------------
# Plotting

#Get the position in the dataframe for the first tp samples for H group and P group (H has 2 tp, p has 4)
ph<-grep("^H.+_2", colnames(d))
pp<-grep("^P.+_2", colnames(d))

#lets do the patient data first (4tp)


#Also make an empty matrix to hold the plotted data for calculating means
data<-matrix(ncol=length(pp), nrow=3)

k<- c(-1, 1, 2)

#fake plot area
#Making 3 plots at x-axt positions 1, 2, 3
plot(-1, xlim=c(0.5,3.5), ylim=c(min(d),max(d)))

#for each sample at tp 1
for (i in pp){
	#need the next 3 values to compare to i
	for (j in k){
		pp2<-i+j
	#get data for means
		jj<-grep(i, pp)	#Need the position, not the value to fill in matrix
		kk<-which(k==j)
		data[kk,jj] <- d[i,pp2]

#	stripchart(d[i,pp2], method="jitter", jitter=0.2, pch=20, vertical=TRUE, at=kk, add=TRUE)
	
	}
}

#-------------------------
#Line plot

plot(-1, xlim=c(0.5,3.5), ylim=c(min(d),max(d)))

col<-rainbow(10)

for (n in 1:length(data[1,])){
	xcor<-jitter(c(1,2,3))
	points(xcor, data[,n], col=col[n])
	lines(xcor, data[,n], col=col[n])
}


#-------------------------------------------------------------------------

