###################################
# Media Coverage of Trump: NYT, NYP
# Topic Models: topicmodels library
# Exploration for choice of K
# Michele Claibourn
# February 14, 2017
# Updated February 13, 2019
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
load("newspaperMoral.RData")


####################
# Topic Model 
# using topicmodels
####################
# 0. Prepping 
nydfm <- dfm(qcorpus2, remove = c(stopwords("english"), "mr", "trump", "trump's"), 
             stem = TRUE, removePunct = TRUE, verbose=TRUE) # turn it into a document-feature matrix

# Trim low frequency words, and words that appear across few documents (to reduce the size of the matrix)
nydfmReduced <- dfm_trim(nydfm, min_count = 100, min_docfreq = 3, max_docfreq = 1960)

# Remove empty rows and confert to a tm corpus (the topicmodels package expects the triplet matrix format used by tm)
nydfmReduced <- nydfmReduced[which(rowSums(nydfmReduced) > 0),]
nydtm <- convert(nydfmReduced, to="topicmodels")


# 1. Evaluating K
# Evaluating k on held-out data, using VEM approximation
# sample held-out data (test) and estimating data (train)
set.seed(121) # for reproducibility
train_size <- floor(0.75 * nrow(nydtm)) # 75% of sample
train_index <- sample(seq_len(nrow(nydtm)), size=train_size)

train <- nydtm[train_index,]
test <- nydtm[-train_index,]

# Across a range of K (50,100,150,200,250)
# Try running this in parallel,
library(parallel)
numCores <- detectCores() - 1
seed1 <- 12171
trainK <- mclapply(seq(50,250,50), function(k){LDA(train, k)}, mc.cores=numCores)
perplexityK <- mclapply(trainK10, function(k){perplexity(k, test)}, mc.cores=numCores)

# Graph
# px <- unlist(perplexityK)
# perplexline <- as.data.frame(cbind(px, k=c(50,100,150,200,250))) # and add k values
# ggplot(perplexline, aes(x=k, y=px)) + geom_line() + scale_x_continuous(breaks=c(50,100,150,200,250))

save.image("newspaperTopicModelEval.RData")