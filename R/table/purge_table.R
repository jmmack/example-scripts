#This script uses a vector of column names to remove these columns from a dataframe

d <- read.table("TableS1.txt", header=T, sep="\t", quote="", row.names=1, check.names=F, skip=1, comment.char="")


> dim(d)
[1]  77 324

colnames(d)

rem<-c("100bvvc", "109bvvc", "110bvvc", "127bvvc", "128bvvc", "133bvvc", "134bvvc", "147bvvc", "148bvvc", "151bvvc", "152bvvc", "161bvvc", "162bvvc", "177bvvc", "178bvvc", "179bvvc", "180bvvc", "83bvvc", "84bvvc", "87bvvc", "88bvvc", "91bvvc", "92bvvc", "97bvvc", "98bvvc", "99bvvc")


for(i in 1:length(rem)){
	d[,i]<-NULL
}

> dim(d)
[1]  77 298
#taxonomy column

write.table(d, file="TableS1_update.txt", sep="\t", quote=FALSE, col.names=NA)


#------------------------------------
#dataframe[,2]<-NULL
