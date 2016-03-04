Using strsplit() to split text
Example: a dataframe with a column of taxon IDs. Getting the genus + species short name for taxonomy
V1 V2
1 fig|883.3.peg.2149 Desulfovibrio vulgaris str. 'Miyazaki F'
2 fig|1085.1.peg.627 Rhodospirillum rubrum
3 fig|1085.1.peg.628 Rhodospirillum rubrum
4 fig|12149.1.peg.653 Salmonella bongori 12149
5 fig|12149.1.peg.654 Salmonella bongori 12149
6 fig|12149.1.peg.655 Salmonella bongori 12149

split<-strsplit(as.vector(d[,2]), "")

Access:

> split[[1]]
[1] "Desulfovibrio""vulgaris""str.""'Miyazaki""F'"
> split[[1]][1]
[1] "Desulfovibrio"

Example: Split on a character AND looping and appending to a list
#make an empty list
taxlist=list()

tax<-strsplit(rownames(y), ";")
taxlist=list()
for(i in 1:length(tax)){
taxlist[length(taxlist)+1]<-tax[[i]][6]
}

Example: Split and add first element to a new column

# split taxa on space and add genus (first split) in new column
# Need to use named columns

> colnames(d)
[1] "V1""V2"
# splitting column 2 in "d" on every character ""
> d$V3 <- sapply(strsplit(as.character(d[,2]), ""), "[", 1)

# Getting the column as a table
> d_table <- table(d[,3])

You can also use "[",2 to get second element, etc.
http://stackoverflow.com/questions/4350440/using-strsplit-with-data-frames-to-split-label-columns-into-multiple
