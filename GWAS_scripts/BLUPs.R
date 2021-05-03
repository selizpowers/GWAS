library(lme4)
df <- read.csv("blups.csv")
head(df)
#add for all variables to incorporate in model
df$REP <- as.factor(df$REP)
df$TAXA <- as.factor(df$TAXA)
df$DATE1 <- as.factor(df$DATE1)
df$DATE2 <- as.factor(df$DATE2)
first_trait_column = 4 #where first phenotype appears
trait_columns = 0 #number of trait columns - 1
for (i in first_trait_column :first_trait_column + trait_columns){
its_only_a_model <- lme4::lmer(paste0(names(df[i])[1], " ~(1|TAXA) + (1|REP) + (1|DATE)"), data = df)
random_effects <- lme4::ranef(its_only_a_model)
write.csv(random_effects$TAXA, file=paste0(paste0(names(df[i])[1], "_blups.csv")),
quote = FALSE)
print(head(random_effects$TAXA))
}
