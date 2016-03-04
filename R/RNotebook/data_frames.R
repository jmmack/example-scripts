d <- read.table("table.txt", header=T, sep="\t", quote="", row.names=1, check.names=F)

Access data in the dataframe

df$10A #Get a column (by name)
df[“Lactobacillus", ] #Get a row (by name)

Add a row to an existing data frame
http://gregorybooma.wordpress.com/2012/07/18/add-an-empty-column-and-row-to-an-r-data-frame/

#assuming you have a dataframe "y"
newrowname<-"rem"
# create a one-row matrix the same length as data containing "0" for each value (rep.int)
temprow <- matrix(c(rep.int(0,ncol(y))),nrow=1,ncol=ncol(y))
# make it a data.frame and give cols the same names as data
newrow <- data.frame(temprow)
colnames(newrow) <- colnames(y)
rownames(newrow) <-newrowname
# rbind the empty row to data
y <- rbind(y,newrow)

# Remove a complete column or row from a data frame

dataframe[,2]<-NULL

# rbind and cbind to add a row or column to a dataframe
file://localhost/Volumes/rhamnosus/reference_genomes/may2013/cluster/cd-hit/seq_length_dist_summary.R

Pull out columns to another data frame and keep data frame structure (rownames and colnames)

dd<-d[1:4] #columns 1 to 4
dd<-d[,1:4] #works too
dd<-d[c("10A", "22A")] #name also works

Sum up columns
colSums(d)
