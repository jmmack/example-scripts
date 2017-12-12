arr.ind = FALSE

for (i in 1:length(levels(d$a_dis))){
	test<-d$"#SampleID"[which(d$a_dis==levels(d$a_dis)[i])]
}

#Test data


d<-read.table("Downloads/otu_example.txt", header=T, sep="\t", quote="", check.names=F, comment.char="", row.names=1)
m<-read.table("Downloads/metadata_example.txt", header=T, sep="\t", quote="", check.names=F, comment.char="", row.names=1)


points <- c(rep("o", length(dimnames(d.pcx$rotation)[[1]]))) # for ylabs

#samples, then features
col=c("black",rgb(1,0,0,0.2))
c=c(0.5, 0.5) #Relative scale, 1 is 100%


coloredBiplot(d.pcx, cex=c, col=col, var.axes=F,
    xlab=paste("PC1: ", round(sum(d.pcx$sdev[1]^2)/d.mvar, 3)),
    ylab=paste("PC2: ", round(sum(d.pcx$sdev[2]^2)/d.mvar, 3)),
    scale=0, ylabs=points, xlabs.col
)
dev.off()


#this makes a vector with 5 red and 5 blue
sc<-c(rep("red", 5), rep("blue", 5))


#Need a vector list of colors for the number of unique metadata
#needs to be in the same order as your table


col<-c("red", "blue", "yellow", "pink", "green")

#number of things you need
nlevels(d$a_dis)

t<-factor(d$a_dis)
 [1] n n n n n n n n n n y n y y y n y n y y y y y n y n



