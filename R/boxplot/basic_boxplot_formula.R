#make sure you are capturing the header information
input <- read.table("shan.txt", sep="\t", header=T)

#plot the shannon values by each unique d_bw value
boxplot(data=input, shannon~d_bw)

