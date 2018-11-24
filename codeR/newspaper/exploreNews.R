###################################################################
# Media Coverage of Trump: NYT, WSJ, WP
# Initial Exploration 
# Michele Claibourn
# Creaed February 21, 2017
# Updated November 24 to include through October 31, 2018
###################################################################


###################################################################
# Loading libraries, Setting directories, Loading data ----

# install.packages("scales")
# install.packages("wordcloud")
# install.packages("RColorBrewer")

rm(list=ls())
library(tidyverse)
library(quanteda)
library(scales)
library(wordcloud)
library(RColorBrewer)
library(lubridate)


# Load the data and environment from readNews.R
setwd("~/Box Sync/mpc/dataForDemocracy/presidency_project/newspaper/")
load("workspaceR_newspaper/newspaper.Rdata")


###################################################################
# Exploration: volume of news articles ----

# Some descriptives
summary(qmeta$length)
qmeta %>% group_by(pub) %>% 
  summarize(mean(length, na.rm = TRUE), sd(length, na.rm = TRUE))
qcorpus2 <- corpus_subset(qcorpus, as.integer(length) > 99)

table(qmeta$pub)
qmeta$pub <- as.factor(qmeta$pub)
qmeta2 <- subset(qmeta, as.integer(length) > 99)
table(qmeta2$pub)

# Number of stories by day
# Create date breaks to get chosen tick marks on graph
date.vec <- seq(from = as.Date("2017-01-20"), to = as.Date("2018-11-02"), by="2 weeks") # update to Friday after last story
ggplot(qmeta2, aes(x = date)) + geom_point(stat = "count") + 
  facet_wrap(~pub) +
  scale_x_date(labels = date_format("%m/%d"), breaks = date.vec) + 
  labs(title = "Volume of Trump Coverage", 
       subtitle = "New York Times, Washington Post, Wall Street Journal", 
       x = "Date", y = "Number of Stories") +
  theme(axis.text.x = element_text(angle = 90, size = 8), 
        plot.title = element_text(face = "bold", size = 18, hjust = 0), 
        axis.title = element_text(face = "bold", size = 16),
        panel.grid.minor = element_blank(),
        legend.position="none")
ggsave("figuresR/newspapervolume.png")


###################################################################
# Exploration: Key words in context, word frequency ----

fakecount <- kwic(qcorpus2, "fake", 3)
head(fakecount)
tail(fakecount)

immig <- kwic(qcorpus2, "immig*", window = 2)
head(immig)
tail(immig)

# Frequent words/Wordclouds
qcorpus_tokens  <- tokens(qcorpus2) 
qcorpus_tokens <- tokens_remove(qcorpus_tokens, stopwords("english"), padding = TRUE)

npdfm <- dfm(qcorpus_tokens, remove_punct = TRUE, 
             ngrams = 1:2, verbose = TRUE) # turn it into a document-feature matrix
topfeatures(npdfm, 100) 
palD <- brewer.pal(8, "Paired")
textplot_wordcloud(npdfm, max_words = 200, min_size = 0.5, max_size= 3, color = palD)

# Wordcloud by source
bynpdfm <- dfm(qcorpus_tokens, groups = "pub",
                  remove_punct = TRUE, ngrams = 1:2, verbose = TRUE)

palO <- colorRampPalette(brewer.pal(9,"Oranges"))(32)[13:32]
palB <- colorRampPalette(brewer.pal(9,"Blues"))(32)[13:32]

textplot_wordcloud(bynpdfm[1], max_words = 200, color = palB, min_size = 0.5, max_size = 3) # nyt
textplot_wordcloud(bynpdfm[2], max_words = 200, color = palO, min_size = 0.5, max_size = 3) # wsj
textplot_wordcloud(bynpdfm[3], max_words = 200, color = palB, min_size = 0.5, max_size = 3) # wp 

# Wordcloud of opinion-editorial pieces
qcorpus_oped <- corpus_subset(qcorpus2, oped==1)
qcorpus_oped_tokens  <- tokens(qcorpus_oped) 
qcorpus_oped_tokens <- tokens_remove(qcorpus_oped_tokens, stopwords("english"))
bynpdfmoped <- dfm(qcorpus_oped_tokens, groups = "pub", remove_punct = TRUE)

textplot_wordcloud(bynpdfmoped[1], max_words = 150, color = palB, min_size = 0.5, max_size = 3) # nyt
textplot_wordcloud(bynpdfmoped[2], max_words = 150, color = palO, min_size = 0.5, max_size = 3) # wsj
textplot_wordcloud(bynpdfmoped[3], max_words = 150, color = palB, min_size = 0.5, max_size = 3) # wp

# Plot keyness
qcorpus_tokens %>% dfm(groups = "pub", remove = c(stopwords("english")),
                       remove_punct = TRUE, ngrams = 1:2) %>% 
  textstat_keyness(target = "WSJ") %>% textplot_keyness()


###################################################################
# Use of the language of fake and lie/s ----
# (possibly others, e.g., honest?); just for exploration...

fakelies <- dictionary(list(lies = c("lie", "lied", "lies"), fake = "fake"))
fakeliedfm  <- dfm(qcorpus2, dictionary = fakelies)
head(fakeliedfm, 10)

# Turn this into a dataframe
paperfakelie <- convert(fakeliedfm, to = "data.frame")
qmeta2[,ncol(qmeta2)+1:2] <- paperfakelie[,2:3]

# Group by week
byweek <- qmeta2 %>% 
  mutate(week=week(date)) %>% 
  group_by(week, pub) %>% 
  summarize(fake=sum(fake), lie=sum(lies))

# Plot!
ggplot(byweek, aes(x=week, y=lie)) +
  geom_jitter(aes(color=pub), alpha=0.05, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$anger), color="gray50") +
  geom_smooth(aes(color=pub)) +
  labs(title = "Frequency of 'Lies' in Trump Coverage",
       subtitle = "New York Times, Washington Post, Wall Street Journal", 
       y = "Anger Affect", x = "Date of Article") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=18, hjust=0),
        axis.title = element_text(face="bold", size=14),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=12))

ggplot(byweek, aes(x=week, y=fake)) +
  geom_jitter(aes(color=pub), alpha=0.15, width=0.2, height=0.0, size=2) +
  geom_hline(yintercept=mean(qmeta2$anger), color="gray50") +
  geom_smooth(aes(color=pub)) +
  labs(title = "Frequency of 'Fake' in Trump Coverage",
       subtitle = "New York Times, Washington Post, Wall Street Journal", 
       y = "Anger Affect", x = "Date of Article") +
  scale_color_manual(values=c("blue3", "turquoise", "orange3"), name="Source") +
  theme(plot.title = element_text(face="bold", size=18, hjust=0),
        axis.title = element_text(face="bold", size=14),
        panel.grid.minor = element_blank(), legend.position = c(0.95,0.9),
        axis.text.x = element_text(angle=90),
        legend.text=element_text(size=12))

# Save work
rm("palD", "palO", "palB", "paperfakelie", "fakeliedfm", "fakelies", "fakecount", "immig")
save.image("workspaceR_newspaper/newspaperExplore.RData")
# load("workspaceR_newspaper/newspaperExplore.RData")


###################################################################
# Save for later ----
## Clean up terms
# common bigrams
# qcorpus_tokens  <- tokens(qcorpus2) # textstat_collocations wants tokenized text
# qcorpus_tokens <- tokens_remove(qcorpus_tokens, stopwords("english"), padding = TRUE)
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


