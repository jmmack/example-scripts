#d <- read.table("/Volumes/iners/brazil_dec2012/analysis/R_plots/clinical_heatmap/amsel_nugent.txt", header=T)
#d <- read.table("/Volumes/iners/brazil_dec2012/analysis/R_plots/clinical/amsel_nugent_numeric.txt", header=T, quote="")
d <- read.table("/Volumes/iners/brazil_dec2012/analysis/R_plots/clinical/amsel_nugent_numeric_blanks.txt", header=T, quote="")

#(nugent)
#n=0
#n/i=1
#i=2
#bv=3

#(other)
#n(no)=0
#y(yes)=1
#
#ND= -1

#BV has no missing edata except for clue cells
#VVC has n/i while n and i are separate for BV

opar<-par(no.readonly = TRUE)


#numeric_blanks is already sorted
#get the binary data
tmp1 <- cbind( d$a_dis, d$a_whiff, d$a_ph)

#get nugent
tmp2 <- cbind(d$n_status)

#d_sort<-d[order(d$plot_order),]

#tmp1 <- cbind( d_sort$a_dis, d_sort$a_whiff, d_sort$a_ph, d_sort$a_clue )
#tmp1 <- cbind( d_sort$a_dis, d_sort$a_whiff, d_sort$a_ph, d_sort$n_status)
#tmp2 <- cbind(d_sort$n_status)

#Change to horizontal orientation if you want to
#tmp <- t(tmp)

#Provide a list of colors to use
# Define the breaks for moving to the next color (in this case, values went from 0 to 4 and a color change occurs every +0.5. This
#     sets one color per value: gray75=0, gray50=1, etc.)

col=c("white", "white", "gray25")
ncol=c("white", "gray75", "gray75", "gray25", "white")


#col=c("white", "white", "black")
#ncol=c("blue", "yellow", "yellow", "red", "white")
#N:0, N/I:1, I:2, BV:3, ND:-1
# I want I and N/I to be the same color. N/I only occurs in VVC

pdf("plot_symptom.pdf", height=1, width=16)
par(mfrow=c(2,1), mar=c(0.25,0,0,0), oma=c(0,1,0,1))
#image(tmp1[1:31, 1:ncol(tmp1)], col=c("gray", "gray0", "gray1", "gray2", "white"), breaks=(0:5-0.5), xaxt="n", yaxt="n")
image(tmp1, col=col, breaks=(-1:2-0.5), axes=FALSE)
image(tmp2, col=ncol, breaks=c(-0.5,0.5,1.5,2.5,3.5,4.5), axes=FALSE)

#image(tmp2, col=c("white", "gray75", "gray50", "gray25", "gray0"), breaks=(-1:4-0.5), axes=FALSE)
#-1, 0, 1, 2, 3
#ND, N, N/I, I, BV


dev.off()
