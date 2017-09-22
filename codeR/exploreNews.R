###################################
# Media Coverage of Trump: NYT, WSJ
# Initial Exploration 
# Michele Claibourn
# February 21, 2017
# Updated September 1, 2017
##################################

#####################
# Loading libraries
# Setting directories
#####################
# install.packages("scales")
# install.packages("wordcloud")
# install.packages("RColorBrewer")

rm(list=ls())
library(dplyr)
library(tidyr)
library(ggplot2)
library(quanteda)
library(scales)
library(wordcloud)
library(RColorBrewer)

# Load the data and environment from readNews.R
setwd("~/Box Sync/mpc/dataForDemocracy/newspaper/")
load("workspaceR/newspaper.Rdata")


##################################
# Exploring the text, pre-analysis
##################################
# Some descriptives
summary(as.integer(qmeta$length))
qcorpus2 <- corpus_subset(qcorpus, as.integer(length)>99)

table(qmeta$pub)
qmeta$pub <- as.factor(qmeta$pub)
qmeta2 <- subset(qmeta, as.integer(length)>99)
table(qmeta2$pub)
table(qmeta2$date, qmeta2$pub)

# Number of stories by day
p <- ggplot(qmeta2, aes(x=date)) 
# Create date breaks to get chosen tick marks on graph
date.vec <- seq(from=as.Date("2017-01-20"), to=as.Date("2017-09-01"), by="week") # update to Friday after last story
p + stat_count(aes(fill=..count..), geom="point") + 
  facet_wrap(~ pub) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) + 
  ggtitle("Volume of News Coverage of Trump\n New York Times and Wall Street Journal") +
  labs(x="Date", y="Number of Stories") +
  theme(axis.text.x=element_text(angle=90), 
        plot.title = element_text(face="bold", size=20, hjust=0), 
        axis.title = element_text(face="bold", size=16),
        panel.grid.minor = element_blank(),
        legend.position="none")
ggsave("figuresR/newspapervolume.png")

## Clean up terms
# common bigrams
bigrams <- collocations(qcorpus2, n = 500, size = 2)
bigrams[bigrams$count>1000,]
# exclude collocations with stop words
bigrams <- removeFeatures(bigrams, stopwords("english"))
bigrams
# replace some key phrases with single-token versions
# united states, white house, north korea, health care, national security,
# attorney general, supreme court, executive order, 
qcorpus3 <- phrasetotoken(qcorpus2, bigrams[c(1:2,4:6,8,10,13)])


## Frequent words/Wordclouds
nydfm <- dfm(qcorpus3, remove = c(stopwords("english")), 
             removePunct = TRUE, verbose=TRUE) # turn it into a document-feature matrix
topfeatures(nydfm, 100)
palD <- brewer.pal(8, "Paired")
textplot_wordcloud(nydfm, max.words = 300, colors = palD, scale = c(4, .5))

# Wordcloud by source
bypaperdfm <- dfm(qcorpus3, groups = "pub",
                  remove = c(stopwords("english")),
                  removePunct = TRUE, verbose = TRUE)

palO <- colorRampPalette(brewer.pal(9,"Oranges"))(32)[13:32]
palB <- colorRampPalette(brewer.pal(9,"Blues"))(32)[13:32]

textplot_wordcloud(bypaperdfm[1], max.words = 200, colors = palB, scale = c(4, .5)) # nyt
textplot_wordcloud(bypaperdfm[2], max.words = 200, colors = palO, scale = c(4, .5)) # wsj


## Key words in context (from quanteda)
tweetcount <- kwic(qcorpus3, "tweet", 3)
tweetcount
whitecount <- kwic(qcorpus3, "white", 3)
whitecount


## Readability/Complexity Analysis (from quanteda)
fk <- textstat_readability(qcorpus3, measure = "Flesch.Kincaid")
qmeta2$readability <- fk

# Plot
p <- ggplot(qmeta2, aes(x = date, y = readability))
p + geom_jitter(aes(color=pub), alpha=0.5, width=0.25, height=0.0, size=2) +
  geom_smooth(aes(color=pub)) +
  scale_x_date(labels = date_format("%m/%d"), breaks=date.vec) + 
  ggtitle("'Readability' of Newspaper Coverage of Trump") +
  labs(y = "Readability (grade level)", x = "Date of Article") +
  scale_color_manual(values=c("blue3","orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=20, hjust=0),
        axis.title = element_text(face="bold", size=16),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=10))
ggsave("figuresR/newspaperreadability.png")

qmeta2 %>% group_by(pub) %>% summarize(mean(readability)) 


# Save
rm("p", "fk", "bigrams", "palD", "palO", "palB")
save.image("workspaceR/newspaperExplore.RData")
<<<<<<< HEAD
# load("workspaceR/newspaperExplore.RData")
=======
# load("workspaceR/newspaperExplore.RData")
>>>>>>> origin/master
