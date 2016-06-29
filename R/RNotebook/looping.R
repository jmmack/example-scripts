Example looping and pulling IDs by name and then condition

IDs: F1-G1 (Farm 1, Good 1)

n<-13 #I have 13 farms
var <- NULL
conds <- c("G", "B")

for(i in 1:n){
	for (j in conds){
		d.m<-as.matrix(d[,grep(paste("F",i,"-",j,sep=""), colnames(d))])
		otu<-rownames(d.m)
		rownames(d.m)<-paste(otu, tax, sep="_")

		count = 1
		d.0 <- data.frame(d.m[which(apply(d.m, 1, function(x){sum(x)}) > count),], check.names=F)

		d.czm <- cmultRepl(t(d.0),  label=0, method="CZM")

		d.clr <- t(apply(d.czm, 1, function(x){log(x) - mean(log(x))}))

		d.pcx <- prcomp(d.clr)

		var <- rbind(var, data.frame(rowSums(d.pcx$x)))
	}
}

write.table(var, file="total_variance.txt", sep="\t", quote=F, col.names=NA)
