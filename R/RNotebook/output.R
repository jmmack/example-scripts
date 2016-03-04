Add the missing \t at beginning of header when using write.table:
"By default there is no column name for a column of row names. If col.names = NA and row.names = TRUE a blank column name is added, which is the convention used for CSV files to be read by spreadsheets."
http://stackoverflow.com/questions/2478352/write-table-in-r-screws-up-header-when-has-rownames

Example:
write.table(pcor_cor, file=paste("pcor_", k, ".txt", sep=""), sep="\t", quote=F, col.names=NA)
Use row.names=F if you want to remove rownames (esp. default R numbering)

#Add the first colname back to the header
header<-c("subsys4", colnames(at))
write.table(x, file="aldex_out.txt", sep="\t", quote=FALSE, col.names=header)

# Write to plain text file
write(d, "out.txt")

#--------------
# Print out to terminal
cat("mc.samples=", mc.samples, " t.significant=", t.significant, " t.meaningful=", t.meaningful, "\n", sep="")

will give:
> source("run_kegg.r")

mc.samples=1024 t.significant=0.01 t.meaningful=1.7

Or use: print("this is what you are printing")
#--------------
# Send output to file
# direct output to a file
sink("ALDEx_log.txt", append=TRUE, split=TRUE)
# return output to the terminal
sink()
The append option controls whether output overwrites or adds to a file. The split option determines if output is also sent to the screen as well as the output file.
