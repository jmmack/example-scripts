greg<-c(1,3,7,12,20,18,19,1)
andrew<-c(1,1,1,1,19,16,10,10)
amy<-c(1,1,1,2,1,1,1,1)
jean<-c(3,3,3,3,3,3,3,3)
ruth<-c(1,6,7,7,2,10,2,2)


pdf("priors.pdf")

par(mar=c(3,3,3,2.1), oma=c(1,0,0,5))
plot(greg, type="b", lty=1, pch=19, main="Interest in priors over time", ylab="", xlab="", yaxt="n", xaxt="n")
points(andrew, type="b", lty=2, pch=0)
points(amy, type="b", lty=3, pch=1)
points(jean, type="b", lty=4, pch=2)
points(ruth, type="b", lty=5, pch=4)
legend("right", legend=c("Greg", "Andrew", "Amy", "Jean", "Ruth"), lty=c(1:5), pch=c(19,0:4), xpd=NA, inset=c(-0.25,0))
mtext("Interest", side=2, line=1)
mtext("Time", side=1, line=1)

dev.off()