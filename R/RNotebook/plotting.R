#-------------------------------------------------
# Formatting line types
#-------------------------------------------------
http://students.washington.edu/mclarkso/documents/line%20styles%20Ver2.pdf

#-------------------------------------------------
# Save par
#-------------------------------------------------

opar<-par(no.readonly=TRUE)
Restore:
par(opar)

#-------------------------------------------------
# Plotting parameters (axes, margins)
#-------------------------------------------------
Make x-axis with ticks for every data row plotted, label ticks by rowname, and rotate text 90degrees:
rownames<-row.names(d)
plot((d$A1a-d$B1a), pch=19, cex=0.7, cex.axis=0.8, ylim=c(-0.6,0.8), ylab="OD600 difference", xaxt = "n", xlab="")
axis(1, at=1:length(rownames), labels=rownames, cex.axis=1, tck=-.01, las=2)
#las represents the style of axis labels. (0=parallel, 1=all horizontal, 2=all perpendicular to axis, 3=all vertical)
#--------------
More axes stuff

Suppress individual axis:
xaxt="n" or yaxt="n"

Suppress all axes
axes=FALSE

#-------------------------------------------------
# Margins!
#-------------------------------------------------
http://research.stowers-institute.org/efg/R/Graphics/Basics/mar-oma/index.htm

mar=c(bottom, left, top, right)

#--------------
# Axes labels at 45 degrees:
Only seems to work in SOME plots and in text() or mtext()
srt=45

stripchart()
# if you want to re-order the stripchart:
# http://tolstoy.newcastle.edu.au/R/e6/help/09/05/15480.html

#stripchart accepts a single numeric vector, or a list of numeric vectors
#need to concatenate as a list (or dataframe - which is list format) to plot multiples

stripchart(list(y,x), vertical=TRUE, method="jitter")
stripchart(data.frame(y,x), vertical=TRUE, method="jitter")
# data frame will keep the name of the vectors

The function stripchart() can also take in formulas of the form y~x where, y is a numeric vector which is grouped according to the value of x

# Assigning color to specific names (instead of cycling through a list)
http://mambobob-raptorsnest.blogspot.ca/2011/01/r-for-beginners-and-intermediate-users_08.html

Method 1) Make an extra column in your input table with the color (using Perl or Excel)

Method 2) Put a color vector into palette.
col.list <- c("red","slategray","seagreen",....,"blue")
palette(col.list)
Then you can use a column in your table (e.g. family) as the grouping structure
plot(PC1, PC2, pch=19, col=family)
BUT this still cycles the colors in order and will be dependent on the number of groupings you have.

See: file://localhost/Volumes/rhamnosus/Solid_Dec2010/transcriptome_mapping/meta/ALDEx_1.0.3_May2012/meta/subsys4/Annotate/MA_plots/plot_MA_function.R

# Make a sequence of colors (i.e. for a heatmap)

# colour is greyscale, sequence from 1 (black) to 0 (white) in steps of 0.25
col=grey(seq(1,0,-0.25))

#alternative:
col=colorRampPalette(c("white","darkblue"))(100)

# Barplots with legends

If y is the matrix:

opar<-par(no.readonly = TRUE)
par(xpd=T, mar=par()$mar+c(0,0,0,4))
barplot(y, space=0.1, col=colours, border=NA)
legend(4.8,1, row.names(y), cex=0.8, fill=colours);
par(opar)
first par will add space on the right sidelegend defines the x,y coordinates to put the legendthe last par will reset the par settings to original
#--------------
# Barplot: add spaces between bars

space in the barplot() function can be a vector:

#barplot(y, space=rep(c(0,0,0,1)), col=colours, las=2)
- This will add a space of 1 every 3 bars, and repeat
#barplot(y, space=rep(c(0,0,1),2), col=colours, las=2)
#barplot(y, space=c(0,0,1,0,0,0), col=colours, las=2)

# Barplot with labels on top of bars (D. Edgell in ggplots)

pdf("bmo_diff_sur_input.pdf", heigh=8, width=12)
x<-barplot (t(diff_bmo), beside=T, border="transparent",space =c(0.2,2), axis.lty=1,ylim=c(-0.2,0.4), col=c("blue","red","green","grey70"), names.arg=pos, ylab="difference in nt freq", xlab="position in randomized substrate", main="difference nt frequency survivors - input")
abline (h=c(0))
abline (h=c(-0.2,-0.1,0.1,0.2,0.3,0.4), lty=3, col="#00000050")
abline (v=x, lty=3,col="#00000050")
for (j in 1:4) {
for (i in 1:14 ) {
ifelse ( (diff_bmo[i,j]) > 0, all(text(x[j,i], diff_bmo[i,j]+0.01,nucs[j])), all(text(x[j,i], diff_bmo[i,j]-0.01,nucs[j] )) )
}
}
box()
dev.off()

# Multiple boxplots on same plot using add=TRUE
- Set xlim and use at= to place plot

par(mfrow=c(1,1))
boxplot(td$"bbv_n_0_vs._bbv_y_0", at=0.5, ylim=c(0,1), xlim=c(0,3))
boxplot(td$"bbv_n_1_vs._bbv_n_0", at=1.5, add=TRUE)
boxplot(td$"bbv_y_0_vs._bbv_y_1", at=2.5, add=TRUE)
dev.off()

# Convert color values from R names, to RGB, to Hex

name to RGB:
> col2rgb("steelblue3")
[,1]
red 79
green 148
blue 205

RGB to hex (with no alpha value in rgb)
rgb(red, green, blue, maxColorValue=255)

Name>rgb>hex
ss<-t(col2rgb("steelblue3"))
rgb(ss, maxColorValue=255)

#Add labels to points on scatterplot/scatterchart

psig <- which(x.all$we.eBH < 0.05 & x.all$diff.btw > 0)

#add labels to points on the plot
text(x.all$diff.win, x.all$diff.btw, labels=row.names(x.all), cex= 0.7, pos=3)

#only the positive significant points
text(x.all$diff.win[psig], x.all$diff.btw[psig], labels=row.names(x.all[psig,]), cex= 0.7, pos=3)

#Add a label to a single (named) point
text(x.all["sample1",]$diff.win, x.all["sample1",]$diff.btw, labels=row.names(x.all["sample1",]), cex= 0.7, pos=3, col="red")
