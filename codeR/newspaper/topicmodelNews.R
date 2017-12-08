###################################
# Media Coverage of Trump: NYT, NYP
# Topic Models: topicmodels library
# Estimation and visualization
# Michele Claibourn
# February 14, 2017
# Updated December 2, 2017 
###################################

#####################
# Loading libraries
# Setting directories
#####################
# install.packages("topicmodels")
# install.packages("ggjoy")
# install.packages("forcats")
# install.packages("ggridges")

rm(list=ls())
library(dplyr)
library(tidyr)
library(ggplot2)
library(quanteda)
library(tm)
library(topicmodels)
library(forcats)
library(ggridges)

# Load the data and environment from exploreNews.R
setwd("~/Box Sync/mpc/dataForDemocracy/newspaper/")
load("workspaceR/newspaperMoral.RData")

####################
# Topic Model Prep
####################
# 0. Prepping 
nydfm <- dfm(qcorpus2, remove = c(stopwords("english"), "mr", "trump", "trump's"), 
             stem = TRUE, remove_punct = TRUE, verbose=TRUE) # turn it into a document-feature matrix
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
# Estimation, k=100
# using topicmodels
#########################
# 1. Estimate model
seed1=823 # for reproducibility
t1 <- Sys.time()
tm75 <- LDA(nydtm, k=100, control=list(seed=seed1)) # estimate lda model with 50 topics
probterms75 <- as.data.frame(posterior(tm75)$terms) # all the topic-term probabilities
probtopic75 <- as.data.frame(posterior(tm75)$topics) # all the document-topic probabilities
Sys.time() - t1 # ~ 7.7 hours


#########################
# Topic Model Exploration
# Estimation, k=100
#########################

# 1. Visualize results
# a. Topic prevalence in corpus
topiclab <- as.data.frame(t(terms(tm75, 5)))
topicsum <- probtopic75 %>% 
  summarize_all(funs(sum))
topicsum <- as.data.frame(t(topicsum))
topicsum$topic <- as.integer(row.names(topicsum))
topicsum$terms <- paste0(topiclab$V1, "-", topiclab$V2, "-", topiclab$V3, "-", topiclab$V4, "-", topiclab$V5)
names(topicsum)[1] <- "prev"
ggplot(topicsum, aes(x=reorder(terms, prev), y=prev)) + 
  geom_bar(stat="identity") + coord_flip()

# b. Topic prevalence by week
# Bind date (from nymeta) to probtopic
probtopic75$id <- row.names(probtopic75)
probtopic75date <- cbind(probtopic75, date=qmeta2$date)

# Group by week
library(lubridate)
topicweek <- probtopic75date %>% 
  mutate(week=week(date)) %>% 
  select(c(1:100,103)) %>% 
  group_by(week) %>% 
  summarize_all(funs(sum))

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

# topic by weeks via ridgeline plot: udpdated with ggridges
ggplot(topicweeklong2, aes(x=week, y=terms2, height=prevalence, group=terms2)) + 
  ggtitle("Topical Prevalence by Week") +
  labs(y = "", x = "Weeks since Inauguration") +
  scale_x_continuous(breaks=seq(5,30,5)) +
  geom_density_ridges(stat="identity", scale = 2, fill="lightblue", color="lightblue") + 
  theme_ridges(font_size=10)
ggsave("figuresR/topicRidgePrevalenceWeek.png")

# c. Topic prevalence by publication
probtopic75pub <- cbind(probtopic75, pub=qmeta2$pub)
# Group by publication
topicpub <- probtopic75pub %>% 
  select(c(1:75,77)) %>% 
  group_by(pub) %>% 
  summarize_all(funs(sum))
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


# 2. Dynamic visualization 
# install.packages(c("LDAvis", "servr"))
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
serVis(json, out.dir = "nypapertopics75toOctober", open.browser = FALSE) # save for upload elsewhere
# see: http://people.virginia.edu/~mpc8t/datafordemocracy/nypapertopics75toOctober/


# 3. Add article topics (probtopics75) to qmeta2
names(probtopic75) <- (c(topicsum$terms, "id"))
qmeta2 <- left_join(qmeta2, probtopic75, by="id")


#  save
save.image("workspaceR/newspaperTopicModel.RData")
# load("workspaceR/newspaperTopicModel.RData")

## Next steps?
# Structural topic model with souce pub, oped as covariates
# Unsupervised clustering for exploration...