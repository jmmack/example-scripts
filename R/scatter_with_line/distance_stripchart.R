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
ph<-grep("^H.+_1", colnames(d))
pp<-grep("^P.+_1", colnames(d))

#lets do the patient data first (4tp)


#Also make an empty matrix to hold the plotted data for calculating means
data<-matrix(ncol=length(pp), nrow=3)


#fake plot area
#Making 3 plots at x-axt positions 1, 2, 3
plot(-1, xlim=c(0.5,3.5), ylim=c(min(d),max(d)))

#for each sample at tp 1
for (i in pp){
	#need the next 3 values to compare to i
	for (j in 1:3){
		pp2<-i+j
		stripchart(d[i,pp2], method="jitter", jitter=0.2, pch=20, vertical=TRUE, at=j, add=TRUE)
		#get data for means
		jj<-grep(i, pp)	#Need the position, not the vlaue to fill in matrix
		data[j,jj] <- d[i,pp2]
	}
}

#-------------------------

# Plot the mean or median line across the data points
#draw line from x0 to x1, and y0 to y1
#segments(x0, y0, x1, y1)

for (n in 1:3){
	segments(n-0.2, mean(data[n,]), n+0.2, mean(data[n,]), lwd=3)
}


#-------------------------------------------------------------------------

