##----------------------------------------------------------------------##
#------------------Moral Foundation Analysis General---------------------#
##----------------------------------------------------------------------##
#	StatLab                                                                #
#	October 18, 2017                                                       #
#	Jessica Mazen                                                          #
##----------------------------------------------------------------------##

library(dplyr)
library(tm)
library(ggplot2)
library(stringr)
library(lingmatch)
library(tokenizers)

# Run readNews.R first
# Run exploreNews.R first
# Run sentimentNews.R first

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


# Plot

p <- ggplot(qmeta2, aes(x=date, y=HarmVirtue))
p + geom_jitter(aes(color=pub), width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$HarmVirtue), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("HarmVirtue MF within Newspaper Coverage of Trump") +
  labs(y = "HarmVirtue", x = "Date of Article") +
  scale_color_manual(values=c("blue3", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=20, hjust=0),
        axis.title = element_text(face="bold", size=16),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=12))

p <- ggplot(qmeta2, aes(x=date, y=HarmVice))
p + geom_jitter(aes(color=pub), width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$HarmVice), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("HarmVice MF within Newspaper Coverage of Trump") +
  labs(y = "HarmVice", x = "Date of Article") +
  scale_color_manual(values=c("blue3", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=20, hjust=0),
        axis.title = element_text(face="bold", size=16),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=12))

p <- ggplot(qmeta2, aes(x=date, y=FairnessVirtue))
p + geom_jitter(aes(color=pub), width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$FairnessVirtue), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("FairnessVirtue MF within Newspaper Coverage of Trump") +
  labs(y = "FairnessVirtue", x = "Date of Article") +
  scale_color_manual(values=c("blue3", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=20, hjust=0),
        axis.title = element_text(face="bold", size=16),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=12))

p <- ggplot(qmeta2, aes(x=date, y=FairnessVice))
p + geom_jitter(aes(color=pub), width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$FairnessVice), color="gray50") +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) +
  ggtitle("FairnessVice MF within Newspaper Coverage of Trump") +
  labs(y = "FairnessVice", x = "Date of Article") +
  scale_color_manual(values=c("blue3", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=20, hjust=0),
        axis.title = element_text(face="bold", size=16),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=12))


# Plot barplot of all MF
head(senMF,10)
semMF_df <- as.data.frame(senMF[1:11])
head(semMF_df)
semMF_colMeans <- as.data.frame(colMeans(semMF_df))
colnames(semMF_colMeans) <- "MeanMF"
semMF_colMeans$MF <- c("HarmVirtue","HarmVice","FairnessVirtue","FairnessVice",
                       "IngroupVirtue","IngroupVice","AuthorityVirtue","AuthorityVice",
                       "PurityVirtue","PurityVice","MoralityGeneral")

p1 <- ggplot(semMF_colMeans, aes(x=MF, y=MeanMF)) +
  geom_bar(stat="identity") +
  xlab("Moral Foundation") +
  ylab("Mean") +
  coord_flip()


p1 + theme_bw() + theme(axis.line = element_line(colour = "black"),
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

p1 <- ggplot(senMF_new, aes(x=MF2, y=meanMF2)) +
  geom_bar(stat="identity") +
  xlab("Moral Foundation") +
  ylab("Mean") +
  coord_flip()

p1 + theme_bw() + theme(axis.line = element_line(colour = "black"),
                        panel.border = element_blank(),
                        panel.grid.major = element_blank(),
                        panel.grid.minor = element_blank(),
                        panel.background = element_blank(),
                        axis.line.x = element_line(color = "black", size = .5),
                        axis.line.y = element_line(color = "black", size = .5),
                        axis.text=element_text(size=14),
                        axis.title=element_text(size=16,face="bold"))




