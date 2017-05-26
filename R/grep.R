grep("F6-",colnames(de), value=T)
#returns the column names matching "F6-"
#default (value=f) returns the column number, and value=T returns the column name

#get the columns from the dataframe
de[,grep("F6-",colnames(de), value=T)]

#Grep for two patterns (OR)
grep("F6-|F7-", colnames(de), value=T)
