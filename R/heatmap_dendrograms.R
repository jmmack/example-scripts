#make a dendrogram

hc <- hclust(dist(d.clr))
plot(hc)

#Make the labels line up (and make the font size smaller)
plot(hc, cex=0.6, hang=-1)

More dendrogram tips to make it pretty:
http://www.sthda.com/english/wiki/beautiful-dendrogram-visualizations-in-r-5-must-known-methods-unsupervised-machine-learning


# Heatmap changing the hclust and dist functions

#try average linkage clustering
av <- function(x) hclust(x, method="average")
man <- function(x) dist(x, method="manhattan")

heatmap.2(t(d.clr), trace="none", col=rev(heat.colors(16)), dendrogram="column", labRow=NA, hclustfun=av, distfun=man)
dev.off()
