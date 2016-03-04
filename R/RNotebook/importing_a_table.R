Read tab-delimited table, ignoring quotes, with first column as row names:

d <- read.table("table.txt", header=T, sep="\t", quote="", row.names=1, check.names=F)
#--------------
Skip lines when reading in table
read.table(skip=n)

Useful for QIIME-style OTU tables
#comment line here
#header
otu_0 ...
#--------------
Keep object names (column names) that start with a number - i.e. Do not add 'X' in front:
add: check.names=FALSE to read.table

#--------------
Add NA to blank cells in a tab-delimited table
Use na.strings="" in read.table

#--------------
Ignore comment characters (usually #)
comment.char=""

# Read an Excel table (doesn't work well)
library("gdata")
?read.xls
