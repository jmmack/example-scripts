#opar<-par(no.readonly = TRUE)

#Expecting sample IDs as rownames, and taxa as column names with raw read counts in the table
d <- read.table("otu_table.txt", header=T, sep="\t", row.names=1, comment.char="", check.names=FALSE, stringsAsFactors=FALSE)
#sample_id	Bacteria;Firmicutes;Bacilli;Lactobacillales;Lactobacillaceae;Lactobacillus_iners
#100bvvc	7665

#Sum OTU/taxon counts for each sample and get fraction values. 1=row 2=col
# IMPORTANT: the first col must be the first OTU col
y <- apply( data.matrix(d[1:nrow(d),1:(ncol(d)-1)]), 1, function(x) { x / sum(x) } )
### PROBLEM: The values are FACTORS instead of INTEGERS because d had rows/columns with characters when imported
# data.matrix() converts factors to integers: http://stackoverflow.com/questions/9480408/convert-factor-to-integer-in-a-data-frame


# Get the taxonomy
# IMPORTANT: the first col must be the first OTU col
bugnames<-colnames(d)
#bugnames<-(d$OTU_ID)
rownames(y)<-bugnames


#------------------------------------------------------------------------
# The following chunk of code will group OTUs together that are in low abundance (<0.01 hard-coded)
#-------------------------------------------------------------------------------
#"rem" row has to exist
newrowname<-"rem"

# create a one-row matrix the same length as data containing "0" for each value (rep.int)
temprow <- matrix(c(rep.int(0,ncol(y))),nrow=1,ncol=ncol(y))

# make it a data.frame and give cols the same names as data
newrow <- data.frame(temprow)
colnames(newrow) <- colnames(y)
rownames(newrow) <-newrowname

# rbind the empty row to data

yy <- rbind(y,newrow)

#check
#rownames(yy)

#### move all bugs present at less than 1% into the "rem" fraction
yy <- apply( yy , 2, function(x) {
	small <- ( x < 0.01 ) #& ( bugnames != "rem" )
	rare <- sum( x[small] )
	x[small] <- 0 # *** NA
	x["rem"] <- x["rem"] + rare
	return(x)
#	return(rare)
} )
#-------------
# End chunk
#------------------

#Should equal 1
total <- apply( y, 2, function(x) { sum(x,na.rm=TRUE) } ) # should be all equal to one
if ( any( abs(total-1) > (.Machine$double.eps*16) ) ) stop("bugs were erroneously created or destroyed")

#-----------------------------
# Dendrogram from UniFrac dm
#-----------------------------
#get as a matrix
dm<-as.matrix(read.table("weighted_unifrac_dm.txt", sep="\t", header=T, row.names=1, comment.char="", check.names=FALSE))

#convert to dist structure
dmf<-as.dist(dm)
#"average" is most similar to UPGMA, apparently
dendro <- hclust(dmf, method="average")


#-----------------------
# Plotting
#-------------------------

#g_colors2 for genus level table with L. iners and L. crisp separate
g_colors2 <- c("steelblue3", "skyblue1", "#cfebff", "indianred1", "mediumpurple1", "olivedrab3", "pink", "#FFED6F", "mediumorchid3", "tan1", "ivory2", "aquamarine3", "#339966", "royalblue4", "mediumvioletred", "#999933", "#666699", "#CC9933", "#006666", "#3399FF", "#993300", "#CCCC99", "#666666", "#FFCC66", "#6699CC", "#663366", "#9999CC", "#CCCC33", "#669999", "#CCCC66", "#CC6600", "bisque", "#9999FF", "#0066CC", "#99CCCC", "#999999", "#FFCC00", "#009999", "#FF9900", "#999966", "#66CCCC", "#CCCCCC")


#Control barplot
pdf("barplot_dendro.pdf", width=12, height=7)

par(mfrow=c(2,1), mar=c(1,3.5,1,1), oma=c(0,0,0,0), cex.axis=0.8)
plot(dendro, axes=F, ylab="", ann=F, hang=-1, xlab=NULL, cex.lab=0.5)

barplot(y[,colnames(dm[,dendro$order])], space=0.1, col=g_colors2, las=2, border=NA, axisnames=FALSE)
mtext("Microbiota fraction", side=2, line=2.5)
dev.off()


#plot the legend separate
pdf('temp_legend.pdf', height=40, width=16)
barplot(keep, space=0, col=g_colors2, ylim=c(-20,0), legend=T)
dev.off()


