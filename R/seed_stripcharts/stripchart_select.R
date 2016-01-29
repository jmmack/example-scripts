#Jul 12/13, 2012 - JM
#Update for meta subsys4 Spept 6, 2012
#Update Feb 26, 2013 for corrected subsys4s at a e-6 cutoff

#---------------------------------------------------------
# From a list of subsystem names, plot these select subsystems on one page (one figure)
#
## NOTES:
#	Specify the lists below
#	Plot sizes are hard-coded into "layout" below. Change as needed
#-----------------------------------------------------------
d <- read.table(file="/Volumes/rhamnosus/Solid_Dec2010/transcriptome_mapping/meta/ALDEx_1.0.3_May2012/meta/subsys4/ALDEx_fixedsubsys4/0correct_lowconfidence/out_ol0.01rel2_seedhier.txt", header=TRUE, sep="\t", quote="")
#subsys4	N4_total	N30_total	B27_total	B31_total	expression.among.q50	expression.within.A.q50	expression.within.B.q50	expression.sample.N4_total.q50	expression.sample.N30_total.q50	expression.sample.B27_total.q50	expression.sample.B31_total.q50	difference.between.q50	difference.within.q50	effect.q50	criteria.significance	criteria.significant	criteria.meaning	criteria.meaningful	sig.both	refseq_id	subsys1	subsys2	subsys3	common_taxonomy



base_col="#00000050"
#xlim <- range(d$difference.between.q50) * 1.05
xlim <- c(-10,10)					#be careful. A couple genes have abs > 10

########################
# Specific to the different levels
subsys_list<-list(list1<-c("Stress Response", "Nitrogen Metabolism", "Cell Division and Cell Cycle"),
list2<-c("Electron donating reactions", "Glycoside hydrolases", "Polysaccharides", "Sugar Phosphotransferase Systems, PTS", "Aromatic amino acids and derivatives"),
list3<-c("Acetyl-CoA fermentation to Butyrate", "Glycogen metabolism", "Cellulosome", "Fructose and Mannose Inducible PTS", "Maltose and Maltodextrin Utilization", "Glycerol and Glycerol-3-phosphate Uptake and Utilization", "Glycerolipid and Glycerophospholipid Metabolism in Bacteria", "CRISPRs")
)

#Also see "layout" below where the plot heights are defined
#################

#put subsys1, subsys2, subsys3, subsys4 in a list
levels <- paste( "subsys", 1:4, sep="" )

#png(file=paste("all_subsys", ".png", sep=""), width=7, pointsize=12, units="in", res=600) #doesnt work for some reason
pdf(file=paste("new_all_selectsubsys", ".pdf", sep=""), width=13)
	#save par setting
opar<-par(no.readonly = TRUE)
par(mar=c(0.5,21.5,0,0), oma=c(2,2,2,2), cex.axis=1, cex.lab=1, las=1)
#nf<-layout(matrix(c(1,2,3), 3, 1, byrow = TRUE), widths=c(1,1,1), heights=c(0.01,0.3,0.6))
###nf<-layout(matrix(c(1,2,3), 3, 1, byrow = TRUE), widths=c(1,1,1), heights=lcm(c(1.5,2.6,3.3)))
#for 2 subsys
nf<-layout(matrix(c(1,2), 2, 1, byrow = TRUE), widths=c(1,1,1), heights=lcm(c(3,5)))
	#SEE the layout
#layout.show(nf)

#for subsys 1 to 3
for (i in 2:3){

	
#e.g. levels[1] sets g to "subsys1"
#g<-"subsys1"
g<-levels[i]

#initiate e
#How can I make e without doing this???
e<-d[d[[g]] == subsys_list[[i]][1],]

for (j in subsys_list[[i]]){
	
	temp<-d[d[[g]] == j,]
#e<-d[which(d$subsys1 == j),]
#e<-subset(d, d$subsys1 == j)
	
#remove unused levels. Problem: subsys1 is a factor with x levles (x = number of unique subsys1). When you plot, all levels are considered.
# Get rid of unused levels (everything but j)
	e<-rbind(e, temp)
}
e<-droplevels(e)

cutoffb <- ((e$difference.between.q50 > 0) & (e$sig.both == TRUE))
cutoffn <- ((e$difference.between.q50 < 0) & (e$sig.both == TRUE))
nocutoff <- ((e$sig.both == FALSE))

bv_sig <- unique( data.frame( group=e[[g]], absolute=e$difference.between.q50)[ cutoffb , ] )
n_sig <- unique( data.frame( group=e[[g]], absolute=e$difference.between.q50)[ cutoffn , ] )
no_sig <- unique( data.frame( group=e[[g]], absolute=e$difference.between.q50)[nocutoff,])

stripchart(absolute ~ group, data=no_sig, method="jitter", jitter=0.25, pch=20, col=base_col, xlim=xlim, cex=1, las=1, xaxt='n')
stripchart(absolute ~ group, data=n_sig, method="jitter", jitter=0.25, pch=20, col="blue", xlim=xlim, cex=1, add=TRUE)
stripchart(absolute ~ group, data=bv_sig, method="jitter", jitter=0.25, pch=20, col="red", xlim=xlim, cex=1, add=TRUE)
mtext(paste("subsys", i, sep=""), line=0.5, side=4, las=0, cex=1)

#Add zero line
abline(v=0, col="black", lty=2)

#add dotted line to separate categories
for (k in 0.5:(length(subsys_list[[i]])+0.5)){
	abline(h=k, lty=3, col="grey60", lwd=2)
}

}
#x-axis and titles
axis(1)
mtext("Median Absolute" ~~ Log[2] ~~ "Difference", line=2.5, side=1, cex=1)
title(main="", line=1, cex.lab=1, outer=TRUE, adj=c(0))

dev.off()
par(opar)
dev.off()
