###################################
# Media Coverage of Trump: NYT, NYP
# Topic Models: topicmodels library
# Exploration for choice of K
# Michele Claibourn
# February 14, 2017
# Updated September 2, 2017
###################################

#####################
# Loading libraries
# Setting directories
#####################
# install.packages("topicmodels")

rm(list=ls())
library(dplyr)
library(tidyr)
library(ggplot2)
library(quanteda)
library(tm)
library(topicmodels)

# Load the data and environment from exploreNews.R
setwd("~/Box Sync/mpc/dataForDemocracy/newspaper/")
load("workspaceR/newspaperSentiment.RData")


####################
# Topic Model 
# using topicmodels
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


# 1. Evaluating K
# Evaluating k on held-out data, using VEM approximation
# sample held-out data (test) and estimating data (train)
set.seed(121) # for reproducibility
train_size <- floor(0.75 * nrow(nydtm)) # 75% of sample
train_index <- sample(seq_len(nrow(nydtm)), size=train_size)

train <- nydtm[train_index,]
test <- nydtm[-train_index,]

# Perplexity using a held-out set (from topicmodels)
seed1 <- 1017
t <- proc.time()
train30 <- LDA(train, k=30, control=list(seed=seed1))
per <- perplexity(train30, test)
proc.time() - t # ~ 45 min

# What's perplexity?
per # value
test30 <- LDA(test, model=train30, control=list(estimate.beta=FALSE, seed=seed1))
str(test30)
# where that value came from
exp(-1*(sum(test30@loglikelihood)/test30@n))

# Now do this across a range of K (40,50,60)
# Try running this in parallel, ~ 129/321 minutes
library(parallel)
numCores <- detectCores() - 1
seed1 <- 12171
t <- proc.time()
trainK10 <- mclapply(seq(40,60,10), function(k){LDA(train, k)}, mc.cores=numCores)
perplexityK <- mclapply(trainK10, function(k){perplexity(k, test)}, mc.cores=numCores)
proc.time() - t
perplex <- c(per, perplexityK) # add perplexity for k=10 to list

# Across another range of K (70,80,90), ~ 228/584 minutes
t <- proc.time()
trainK10 <- mclapply(seq(70,90,10), function(k){LDA(train, k)}, mc.cores=numCores)
perplexityK <- mclapply(trainK10, function(k){perplexity(k, test)}, mc.cores=numCores)
proc.time() - t
perplex <- c(perplex, perplexityK) # combine the perplexity lists

# Across another range of K (100,110), ~ 303/539 minutes
t <- proc.time()
trainK10 <- mclapply(seq(100,110,10), function(k){LDA(train, k)}, mc.cores=numCores)
perplexityK <- mclapply(trainK10, function(k){perplexity(k, test)}, mc.cores=numCores)
proc.time() - t
perplex <- c(perplex, perplexityK) # combine the perplexity lists

px <- unlist(perplex)
perplexline <- as.data.frame(cbind(px, k=c(30,40,50,60,70,80,90,100,110))) # and add k values
ggplot(perplexline, aes(x=k, y=px)) + geom_line() + scale_x_continuous(breaks=c(30,40,50,60,70,80,90,100,110))

save.image("workspaceR/newspaperTopicModelEval.RData")