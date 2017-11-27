###################################
# Media Coverage of Trump: NYT, WSJ
# Initial Exploration 
# Michele Claibourn
# February 21, 2017
# Updated November 3, 2017
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
date.vec <- seq(from=as.Date("2017-01-20"), to=as.Date("2017-11-03"), by="week") # update to Friday after last story
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
qcorpus_tokens  <- tokens(qcorpus2) # textstat_collocations wants tokenized text
qcorpus_tokens <- tokens_remove(qcorpus_tokens, stopwords("english"), padding = TRUE)
# bigrams <- textstat_collocations(qcorpus_tokens, min_count = 100, size = 2) # took about 45 minutes
# bigrams[bigrams$count>1000,]
## replace some key phrases with single-token versions
# save_bigrams <- bigrams[c(1:2,4:6,12:13,24,52,57,64),] # save key bigrams
## united states, white house, national security, health care, north korea,
## executive order, justice department, attorney general, united nations,  
## prime minister, supreme court
# qcorpus3 <- tokens_compound(qcorpus_tokens, save_bigrams) 
## hmmm, qcorpus3 is now a tokens object; 
## also, this didn't do what I'd expected (i.e., replace selected phrases with concatenated phrase)
## https://stackoverflow.com/questions/38931507/create-dfm-step-by-step-with-quanteda


## Frequent words/Wordclouds
nydfm <- dfm(qcorpus_tokens, remove = c(stopwords("english")), 
             remove_punct = TRUE, ngrams = 1:2, verbose = TRUE) # turn it into a document-feature matrix
topfeatures(nydfm, 100) 
palD <- brewer.pal(8, "Paired")
textplot_wordcloud(nydfm, max.words = 300, colors = palD, scale = c(4, .5))

# Wordcloud by source
bypaperdfm <- dfm(qcorpus_tokens, groups = "pub",
                  remove = c(stopwords("english")),
                  remove_punct = TRUE, ngrams = 1:2, verbose = TRUE)

palO <- colorRampPalette(brewer.pal(9,"Oranges"))(32)[13:32]
palB <- colorRampPalette(brewer.pal(9,"Blues"))(32)[13:32]

textplot_wordcloud(bypaperdfm[1], max.words = 200, colors = palB, scale = c(4, .5)) # nyt
textplot_wordcloud(bypaperdfm[2], max.words = 200, colors = palO, scale = c(4, .5)) # wsj

# Plot keyness
qcorpus_tokens %>% dfm(groups = "pub", remove = c(stopwords("english")),
                       remove_punct = TRUE, ngrams = 1:2) %>% 
  textstat_keyness(target = "NYT") %>% textplot_keyness()


## Key words in context (from quanteda)
tweetcount <- kwic(qcorpus_tokens, "tweet", 3)
tweetcount
# qcorpus_tokens %>% kwic("tweet") %>% textplot_xray() # doesn't seem to plot
# whitecount <- kwic(qcorpus2, "white", 3) # without replacing key bigrams with concatenated version, this is meaningless
# whitecount


## Readability/Complexity Analysis (from quanteda)
fk <- textstat_readability(qcorpus2, measure = "Flesch.Kincaid") # back to qcorpus2 (with stopwords)
qmeta2$readability <- fk

# Plot
p <- ggplot(qmeta2[qmeta2$readability<100,], aes(x = date, y = readability))
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

qmeta2 %>% filter(readability<100) %>% 
  group_by(pub) %>% summarize(mean(readability)) 


# Save
rm("p", "fk", "palD", "palO", "palB")
save.image("workspaceR/newspaperExplore.RData")
# load("workspaceR/newspaperExplore.RData")