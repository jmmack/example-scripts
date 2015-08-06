#Modifed Jul 25, 2012 - JM
# CAN source() this

#Update Feb 26 for fixed subsys4 at e-6
#Update Mar 19, 2013 for B. cereus data
#Update 2-Jul-2014: For the new ALDEx2 format

#------------------------------------------------------------------------------------
# New data format - A line for each UNIQUE SEED hierarchy
#------------------------------------------------------------------------------------

TABLE<-readline("Enter the path to your SEED hierarchy input table (no quotes or autocomplete): ")
d <- read.table(file=TABLE, header=TRUE, sep="\t", quote="")

#d <- read.table(file="aldex_subsys4_hier.txt", header=TRUE, sep="\t", quote="")
#d <- read.table(file="/Volumes/rhamnosus/Solid_Dec2010/transcriptome_mapping/meta/ALDEx_1.0.3_May2012/meta/subsys4/ALDEx_fixedsubsys4/0correct_lowconfidence/out_ol0.01rel2_seedhier.txt", header=TRUE, sep="\t", quote="")
#subsys4	N4_total	N30_total	B27_total	B31_total	expression.among.q50	expression.within.A.q50	expression.within.B.q50	expression.sample.N4_total.q50	expression.sample.N30_total.q50	expression.sample.B27_total.q50	expression.sample.B31_total.q50	difference.between.q50	difference.within.q50	effect.q50	criteria.significance	criteria.significant	criteria.meaning	criteria.meaningful	sig.both	refseq_id	subsys1	subsys2	subsys3	common_taxonomy

#color for non-DE subsys4
base_col="#00000050"

#Define your columns of interest
col<-"we.eBH"
#diff<-"diff.btw"
diff<-"effect"
#d[,col]


#make the x-axis symmetrical based on the highest value
xlim <- c(- max(abs(d[,diff])) -0.5, max(abs(d[,diff])) + 0.5)


#----------------

#put subsys1, subsys2, subsys3, subsys4 in a list
levels <- paste( "subsys", 1:4, sep="" )

#assuming only subsys1 to subsys3
for (i in 1:3){
	
#e.g. levels[1] sets g to "subsys1"
#g<-"subsys1"
	g<-levels[i]
	
#get all the unique functions for the current level. [[]] removes quotes around "subsys1"
	groups<-unique(d[[g]])

	ylim<-c(length(groups) - (length(groups)+0.5), length(groups) + 0.5)


#For ALDEx2.0.2.7
	cutoffb <- ((d[,diff] < 0) & (d[,col] <= 0.05))
	cutoffn <- ((d[,diff] > 0) & (d[,col] <= 0.05))
	nocut <- (d[,col] > 0.05)

	bv_sig <- unique( data.frame( group=d[[g]], absolute=d[,diff])[ cutoffb , ] )
	n_sig <- unique( data.frame( group=d[[g]], absolute=d[,diff])[ cutoffn , ] )
	no_sig <- unique( data.frame( group=d[[g]], absolute=d[,diff])[nocut,])
	
pdf(file=paste("subsys",i,".pdf",sep=""), width=10, height=(length(groups) / 5))
#	png(file=paste("subsys",i,".png",sep=""), width=9, height=(length(groups) / 5), units="in", res=300)
#height=(length(groups) / 5),
	
	par(mar=c(3,20,0.5,0.5), cex.axis=0.8, cex.lab=0.6, las=1)
#c(bottom, left, top, right)
	stripchart(absolute ~ group, data=no_sig, method="jitter", jitter=0.25, pch=20, col=base_col, xlim=xlim, cex=0.8)
	
#Use add=TRUE to overplot
	stripchart(absolute ~ group, data=n_sig, method="jitter", jitter=0.25, pch=20, col="blue", xlim=xlim, cex=0.8, add=TRUE)
	stripchart(absolute ~ group, data=bv_sig, method="jitter", jitter=0.25, pch=20, col="red", xlim=xlim, cex=0.8, add=TRUE)

	abline(v=0, col="black", lty=2)
#	title(xlab="Median Absolute Difference" ~~Log[2]~~, line=2, cex.lab=0.8)
	title(xlab="Median Effect Size" ~~(Log[2]), line=2, cex.lab=0.8)
	
	#draw horizonal lines
	for (j in 0.5:(length(groups)+0.5)){
		abline(h=j, lty=3, col="grey70")
	}
	
	dev.off()
	
}

#-----------
# END new data
#-----------




