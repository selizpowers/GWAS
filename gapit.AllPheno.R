#library(GAPIT3)
source("http://www.zzlab.net/GAPIT/emma.txt")
source("http://www.zzlab.net/GAPIT/gapit_functions.txt")



myY <- read.csv("GAPIT_pheno.csv", head=T)           
myG <- read.delim("clean.final.renamed.hapmap.hmp.txt", head = FALSE)
#myCV <- read.table("pca.IBD.txt", head=TRUE)
myGAPIT <- GAPIT(
                 Y=myY,
                 G=myG,
		 Model.selection=T,
                 kinship.cluster=c("average"),
		 kinship.group=c("Mean"),
		 model=c("MLM"),
                 ncpus=4
                 )


