# Read in a tab-delimited table
d<-read.table("/path/to/table.txt", sep="\t", quote="", check.names=F, header=T, row.names=1)
#This makes a data frame. Data frames can have numeric AND character data

# Look at your data
head(d)
str(d)
dim(d)
nrow(d), ncol(d)
rownames(d), colnames(d)

# Get a specific column or row
d[row, col]
d[1,] # first row
d[,1] #first column
d$sampleID #You can also pull a column by name
d[,1:4] #columns 1 to 4
d["001A",] #get a row by name

#summarizing your data
colSums(d) # Sum a column
table(d$taxonomy) # get a contigency table for that column
summary(d) or summary(d$length) #get summary statistics (e.g. quartiles, mean, median)



#--------------------------------------------------------------------------------------
If you want example data, you can use the built-in datasets
e.g. cars
d<-cars
