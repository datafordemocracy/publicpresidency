##----------------------------------------------------------------------##
#------------------Moral Foundation Analysis General---------------------#
##----------------------------------------------------------------------##
#	StatLab                                                                #
#	October 18, 2017                                                       #
#	Jessica Mazen                                                          #
# Updated March 20, 2018
##----------------------------------------------------------------------##

rm(list=ls())
library(tidyverse)
library(scales)

# Run readNews.R first
# Run exploreNews.R first
# Run sentimentNews.R first
setwd("~/Box Sync/mpc/dataForDemocracy/presidency_project/newspaper/")
load("workspaceR/newspaperSentiment.RData")

# Read in & create dictionary
#mfDic <- read.dic("http://moralfoundations.org/sites/default/files/files/downloads/moral%20foundations%20dictionary.dic")
download.file("https://goo.gl/5gmwXq", tf <- tempfile())
mfdict <- dictionary(file = tf, format = "LIWC")

# Moral foundations sentiment analysis
senMF <- dfm(qcorpus2, dictionary = mfdict)
head(senMF,10)

# Turn this into a dataframe, add to existing dataframe
paperMF <- as.data.frame(senMF, row.names = senMF@Dimnames$docs)
# Add to dataframe
qmeta2[,ncol(qmeta2)+1:11] <- paperMF[,1:11]

qmeta2 <- qmeta2 %>% 
  mutate(HarmVirtue=(HarmVirtue/words)*100,
         HarmVice=(HarmVice/words)*100,
         FairnessVirtue=(FairnessVirtue/words)*100,
         FairnessVice=(FairnessVice/words)*100,
         IngroupVirtue=(IngroupVirtue/words)*100,
         IngroupVice=(IngroupVice/words)*100,
         AuthorityVirtue=(AuthorityVirtue/words)*100,
         AuthorityVice=(AuthorityVice/words)*100,
         PurityVirtue=(PurityVirtue/words)*100,
         PurityVice=(PurityVice/words)*100,
         MoralityGeneral=(MoralityGeneral/words)*100)

library(gridExtra)

# Care-Harm
date.vec <- seq(from=as.Date("2017-01-20"), to=as.Date("2018-03-02"), by="2 weeks") # update to Friday after last story
# Plot
ph1 <- ggplot(qmeta2, aes(x=date, y=HarmVirtue)) +
  geom_jitter(aes(color=pub), alpha=0.15, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$HarmVirtue), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("Care MF: Trump Coverage") +
  labs(y = "Care Language", x = "Date of Article") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=16, hjust=0),
        axis.title = element_text(face="bold", size=12),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=10))

ph2 <- ggplot(filter(qmeta2, HarmVice<100), aes(x=date, y=HarmVice)) + 
  geom_jitter(aes(color=pub), alpha=0.15, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$HarmVice), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("Harm MF: Trump Coverage") +
  labs(y = "Harm Language", x = "Date of Article") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=16, hjust=0),
        axis.title = element_text(face="bold", size=12),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=10))

grid.arrange(ph1, ph2, nrow = 1)

# Just opeds
# Plot
phoped1 <- ggplot(filter(qmeta2, oped==1), aes(x=date, y=HarmVirtue)) +
  geom_jitter(aes(color=pub), alpha=0.15, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$HarmVirtue), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("Care MF: Trump Op-Eds") +
  labs(y = "Care Language", x = "Date of Article") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=16, hjust=0),
        axis.title = element_text(face="bold", size=12),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=10))

phoped2 <- ggplot(filter(qmeta2, HarmVice<100 & oped==1), aes(x=date, y=HarmVice)) + 
  geom_jitter(aes(color=pub), alpha=0.15, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$HarmVice), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("Harm MF: Trump Op-Eds") +
  labs(y = "Harm Language", x = "Date of Article") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=16, hjust=0),
        axis.title = element_text(face="bold", size=12),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=10))

grid.arrange(phoped1, phoped2, nrow = 1)

# Ingroup/loyalty-Others/betrayal
pi1 <- ggplot(filter(qmeta2, IngroupVirtue<100), aes(x=date, y=IngroupVirtue)) + 
  geom_jitter(aes(color=pub), alpha=0.15, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$FairnessVirtue), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("Ingroup MF: Trump Coverage") +
  labs(y = "Ingroup Language", x = "Date") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=16, hjust=0),
        axis.title = element_text(face="bold", size=12),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=10))

pi2 <- ggplot(filter(qmeta2, IngroupVice<100), aes(x=date, y=IngroupVice)) + 
  geom_jitter(aes(color=pub), alpha=0.15, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$FairnessVice), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("Outgroup MF: Trump Coverage") +
  labs(y = "Outgroup Language", x = "Date") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=16, hjust=0),
        axis.title = element_text(face="bold", size=12),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=10))

grid.arrange(pi1, pi2, nrow = 1)

# OPEDS: Ingroup/loyalty-Others/betrayal
pioped1 <- ggplot(filter(qmeta2, IngroupVirtue<100 & oped==1), aes(x=date, y=IngroupVirtue)) + 
  geom_jitter(aes(color=pub), alpha=0.15, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$FairnessVirtue), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("Ingroup MF: Trump Op-Eds") +
  labs(y = "Ingroup Language", x = "Date") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=16, hjust=0),
        axis.title = element_text(face="bold", size=12),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=10))

pioped2 <- ggplot(filter(qmeta2, IngroupVice<100 & oped==1), aes(x=date, y=IngroupVice)) + 
  geom_jitter(aes(color=pub), alpha=0.15, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$FairnessVice), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("Outgroup MF: Trump Op-Eds") +
  labs(y = "Outgroup Language", x = "Date") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=16, hjust=0),
        axis.title = element_text(face="bold", size=12),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=10))

grid.arrange(pioped1, pioped2, nrow = 1)



# Plot barplot of all MF
head(senMF,10)
semMF_df <- as.data.frame(senMF[1:11])
head(semMF_df)
semMF_colMeans <- as.data.frame(colMeans(semMF_df))
colnames(semMF_colMeans) <- "MeanMF"
semMF_colMeans$MF <- c("HarmVirtue","HarmVice","FairnessVirtue","FairnessVice",
                       "IngroupVirtue","IngroupVice","AuthorityVirtue","AuthorityVice",
                       "PurityVirtue","PurityVice","MoralityGeneral")

ggplot(semMF_colMeans, aes(x=MF, y=MeanMF)) +
  geom_bar(stat="identity") +
  xlab("Moral Foundation") +
  ylab("Mean") +
  coord_flip() +
  theme_bw() + 
  theme(axis.line = element_line(colour = "black"),
                        panel.border = element_blank(),
                        panel.grid.major = element_blank(),
                        panel.grid.minor = element_blank(),
                        panel.background = element_blank(),
                        axis.line.x = element_line(color = "black", size = .5),
                        axis.line.y = element_line(color = "black", size = .5),
                        axis.text=element_text(size=14),
                        axis.title=element_text(size=16,face="bold"))

# Barplot virtue/vice collapsed
semMF_colMeans
meanMF2 <- c(mean(c(2.18181818,1.81818182)),mean(c(1.54545455,0.27272727)),mean(c(4.54545455,1.09090909)),
             mean(c(3.81818182,0.90909091)),mean(c(0.18181818,0.09090909)),2.81818182)
MF2 <- c("Harm","Fairness","Ingroup","Authority","Purity","MoralityGeneral")
senMF_new <- as.data.frame(cbind(meanMF2,MF2))

ggplot(senMF_new, aes(x=MF2, y=meanMF2)) +
  geom_bar(stat="identity") +
  xlab("Moral Foundation") +
  ylab("Mean") +
  coord_flip() +
  theme_bw() + 
  theme(axis.line = element_line(colour = "black"),
                        panel.border = element_blank(),
                        panel.grid.major = element_blank(),
                        panel.grid.minor = element_blank(),
                        panel.background = element_blank(),
                        axis.line.x = element_line(color = "black", size = .5),
                        axis.line.y = element_line(color = "black", size = .5),
                        axis.text=element_text(size=14),
                        axis.title=element_text(size=16,face="bold"))

# Save
save.image("workspaceR/newspaperMoral.RData")
# load("workspaceR/newspaperMoral.RData")




