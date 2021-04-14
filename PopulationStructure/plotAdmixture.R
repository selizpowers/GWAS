library(RColorBrewer)
tbl = read.table("admix_pop.8.Q")
barplot(t(as.matrix(tbl)), col=brewer.pal(n=8, name="Set1"), xlab="Individual #", ylab="Ancestry", border=NA, space=0)