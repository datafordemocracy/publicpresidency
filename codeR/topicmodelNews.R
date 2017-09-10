###################################
# Media Coverage of Trump: NYT, NYP
# Topic Models: topicmodels library
# Estimation and visualization
# Michele Claibourn
# February 14, 2017
# Updated September 3, 2017 
###################################

#####################
# Loading libraries
# Setting directories
#####################
# install.packages("topicmodels")
# install.packages("ggjoy")

rm(list=ls())
library(dplyr)
library(tidyr)
library(ggplot2)
library(quanteda)
library(tm)
library(topicmodels)
library(forcats)
library(ggjoy)

# Load the data and environment from exploreNews.R
setwd("~/Box Sync/mpc/dataForDemocracy/newspaper/")
load("workspaceR/newspaperSentiment.RData")

####################
# Topic Model Prep
####################
# 0. Prepping 
nydfm <- dfm(qcorpus3, remove = c(stopwords("english"), "mr", "trump", "trump's"), 
             stem = TRUE, removePunct = TRUE, verbose=TRUE) # turn it into a document-feature matrix
nydfm
topfeatures(nydfm, 20)
# stopwords("english") # what words did we remove?

# Trim low frequency words, and words that appear across few documents (to reduce the size of the matrix)
nydfmReduced <- dfm_trim(nydfm, min_count = 100, min_docfreq = 3, max_docfreq = 1960)
nydfmReduced

# Remove empty rows and confert to a tm corpus (the topicmodels package expects the triplet matrix format used by tm)
nydfmReduced <- nydfmReduced[which(rowSums(nydfmReduced) > 0),]
nydtm <- convert(nydfmReduced, to="topicmodels")
nydtm

#########################
# Topic Model Estimation
# Estimation, k=75
# using topicmodels
#########################
# 1. Estimate model
seed1=823 # for reproducibility
t1 <- Sys.time()
tm75 <- LDA(nydtm, k=75, control=list(seed=seed1)) # estimate lda model with 50 topics
probterms75 <- as.data.frame(posterior(tm75)$terms) # all the topic-term probabilities
probtopic75 <- as.data.frame(posterior(tm75)$topics) # all the document-topic probabilities
Sys.time() - t1 # ~3 hours

# 2. Visualize results
# a. Topic prevalence in corpus
topiclab <- as.data.frame(t(terms(tm75, 5)))
topicsum <- probtopic75 %>% 
  summarize_each(funs(sum))
topicsum <- as.data.frame(t(topicsum))
topicsum$topic <- as.integer(row.names(topicsum))
topicsum$terms <- paste0(topiclab$V1, "-", topiclab$V2, "-", topiclab$V3, "-", topiclab$V4, "-", topiclab$V5)
names(topicsum)[1] <- "prev"
ggplot(topicsum, aes(x=reorder(terms, prev), y=prev)) + 
  geom_bar(stat="identity") + coord_flip()

# b. Topic prevalence by day
# Bind date (from nymeta) to probtopic
probtopic75$id <- row.names(probtopic75)
probtopic75date <- cbind(probtopic75, date=qmeta2$date)
# Group by day
topicday <- probtopic75date %>% 
  select(c(1:75,77)) %>% 
  group_by(date) %>% 
  summarize_each(funs(sum)) 

# plot single topic
plottitle <- paste0("Topic 3: ", topiclab$V1[3], "-", topiclab$V2[3], "-", topiclab$V3[3], "-", topiclab$V4[3], "-", topiclab$V5[3])
ggplot(topicday, aes(x=date, y=`3`)) + geom_line() + 
  ggtitle(plottitle)

# plot all of the days (gather from tidyr)
topicdaylong <- gather(topicday, topic, prevalence, -date)
# and merge topic labels to resulting long data frame
topicdaylong$topic <- as.integer(topicdaylong$topic)
topicdaylong2 <- merge(topicdaylong, topicsum, by="topic")
library(forcats) # need to make terms a factor, sorted in the order of overall prevalance (for figure)
topicdaylong2 <- arrange(topicdaylong2, desc(prev)) # sort by overall prevalence
topicdaylong2$terms2 <- as_factor(topicdaylong2$terms) # make factors of terms in this order
ggplot(topicdaylong2, aes(x=date, y=prevalence)) + 
  geom_line() + facet_wrap(~ terms2, ncol=5) + 
  ggtitle("Topic Prevalence by Day")

# c. Topic prevalence by week
# Group by week
library(lubridate)
topicweek <- probtopic75date %>% 
  mutate(week=week(date)) %>% 
  select(c(1:75,78)) %>% 
  group_by(week) %>% 
  summarize_each(funs(sum))

# plot the weeks
topicweeklong <- gather(topicweek, topic, prevalence, -week)
# and merge topic labels to resulting long data frame
topicweeklong$topic <- as.integer(topicweeklong$topic)
topicweeklong2 <- merge(topicweeklong, topicsum, by="topic")
topicweeklong2 <- arrange(topicweeklong2, prev) # sort by overall prevalence
topicweeklong2$terms2 <- as_factor(topicweeklong2$terms) # make factors of terms in this order
ggplot(topicweeklong2, aes(x=week, y=prevalence)) + 
  geom_line() + facet_wrap(~ terms2, ncol=5) + 
  ggtitle("Topic Prevalence by Week")

# topic by weeks via joyplot
ggplot(topicweeklong2, aes(x=week, y=terms2, height=prevalence, group=terms2)) + 
  ggtitle("Topical Prevalence by Week") +
  labs(y = "", x = "Weeks since Inauguration") +
  scale_x_continuous(breaks=seq(5,30,5)) +
  geom_joy(stat="identity", scale = 2, fill="lightblue", color="lightblue") + 
  theme_joy(font_size=10)
ggsave("figuresR/topicJoyPrevalenceWeek.png")

# d. Topic prevalence by publication
probtopic75pub <- cbind(probtopic75, pub=qmeta2$pub)
# Group by publication
topicpub <- probtopic75pub %>% 
  select(c(1:75,77)) %>% 
  group_by(pub) %>% 
  summarize_each(funs(sum))
topicpub <- as.data.frame(t(topicpub)) # transpose
topicpub <- topicpub[-1,] # get rid of first row containing publication
names(topicpub) <- c("NYT", "WSJ") # make publication a variable name
topicpub$NYT <- as.numeric(as.character(topicpub$NYT))
topicpub$WSJ <- as.numeric(as.character(topicpub$WSJ))
topicpub <- topicpub %>% 
  mutate(NYTp = (NYT/sum(NYT))*100, WSJp = (WSJ/sum(WSJ))*100)
topicpub$topic <- as.integer(row.names(topicpub))
topicpub$terms <- paste0(topiclab$V1, "-", topiclab$V2, "-", topiclab$V3, "-", topiclab$V4, "-", topiclab$V5)
# plot each separately
ggplot(topicpub, aes(x=reorder(terms, NYTp), y=NYTp)) + 
  geom_bar(stat="identity") + coord_flip()
ggplot(topicpub, aes(x=reorder(terms, WSJp), y=WSJp)) + 
  geom_bar(stat="identity") + coord_flip()

# on same plot
topicpublong <- gather(topicpub, NYTp, WSJp, key="pub", value="prev") 
ggplot(topicpublong, aes(x=reorder(terms, prev), y=prev, fill=pub)) +
  geom_bar(stat="identity", position="dodge", width=0.5) +
  scale_fill_manual(values=c("blue3","orange3")) + 
  labs(x="Topic", y="Prevalence Percent") +
  coord_flip() + ggtitle("Topic Prevalence by Publication")
ggsave("figuresR/topicprevalencepub.png")


# 3. Dynamic visualization 
library(LDAvis)
library(servr)
# i. phi=probterms
#    0 values aren't allowed in later calculations; 
#    add small constant to every value and rescale so it sums to 1
phi <- t(apply(t(probterms75) + .002, 2, function(x) x/sum(x)))
# ii. theta=probtopics
theta <- probtopic75
theta <- theta[,1:75]
# iii. doc.length (number words in each document, create from DTM)
doc.length <- slam::row_sums(nydtm)
# iv. vocab (create from column names in phi)
vocab <- names(probterms75)
# v. term.frequency (create from column sums in DTM)
term.frequency <- slam::col_sums(nydtm)

# Create web visualization
json <- createJSON(phi = phi, theta = theta, 
                   doc.length = doc.length, vocab = vocab, 
                   term.frequency = term.frequency, R = 20)

# Serve up files for display
serVis(json, out.dir = "nypapertopics75", open.browser = FALSE) # save for upload elsewhere
# see: http://people.virginia.edu/~mpc8t/datafordemocracy/nypapertopics75toAugust/


#  save
save.image("workspaceR/newspaperTopicModel.RData")
# load("workspaceR/newspaperTopicModel.RData")

## Next steps?
# Structural topic model with souce pub as covariate
# Unsupervised clustering for exploration...
