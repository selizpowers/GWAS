#library(GAPIT3)
source("http://www.zzlab.net/GAPIT/emma.txt")
source("http://www.zzlab.net/GAPIT/gapit_functions.txt")



myY <- read.csv("GAPIT_pheno.csv", head=T)           
myG <- read.delim(".hmp.txt", head = FALSE)
#myCV <- read.table("pca.IBD.txt", head=TRUE)
myGAPIT <- GAPIT(
                 Y=myY,
                 G=myG,
		 Model.selection=T,
                 kinship.cluster=c("average"),
		 kinship.group=c("Mean"),
		 SNP.MAF = 0.05,
		 model=c("MLM", "Blink", "CMLM", "MLMM"),
                 ncpus=4
                 )


