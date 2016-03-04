# transpose
# Transposing changes a dataframe into a 2D list. To KEEP the data structure do the following:
reads <- as.data.frame(t(dm))

#--------------
# Remove un-used levels from factors:
e<-droplevels(e)

# Drop a levels in a factor by name
# See SEED_stripcharts_aldex2_update.R
groups<-unique(d[[“subsys1"]])
groups <- droplevels(subset(groups, groups != "Clustering-based subsystems"))

#drop levels in a factor by greping part of a name
groups <- droplevels(groups[-grep("CBSS", groups)])

***NOTE: It’s better to drop from the data frame upfront and then do d<-droplevels(d)

d <- subset(d, d$subsys1 != "Clustering-based subsystems")
d <- d[-grep("CBSS", d$subsys3),]

d$subsys1<-droplevels(d$subsys1)  #drop unused levels (R remembers them for some reason)
d$subsys3<-droplevels(d$subsys3)
