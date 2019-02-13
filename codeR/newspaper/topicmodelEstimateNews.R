###################################
# Media Coverage of Trump: NYT, NYP
# Topic Models: topicmodels library
# Estimation and visualization
# Michele Claibourn
# February 14, 2017
# Updated February 10, 2019 
###################################

#####################
# Loading libraries
# Setting directories
#####################

library(quanteda)
library(tm)
library(topicmodels)

# Load the data and environment from moralfoundations1.R
load("newspaperMoral.RData")


####################
# Topic Model Prep
####################
# 0. Prepping 
npdfm <- dfm(qcorpus2, remove = c(stopwords("english"), "mr", "trump", "trump's"), 
             stem = TRUE, remove_punct = TRUE, verbose=TRUE) # turn it into a document-feature matrix
# stopwords("english") # what words did we remove?

# Trim low frequency words, and words that appear across few documents (to reduce the size of the matrix)
npdfmReduced <- dfm_trim(npdfm, min_termfreq = 100, min_docfreq = 50, max_docfreq = nrow(npdfm) - 50)

# Remove empty rows and convert to a tm corpus (the topicmodels package expects the triplet matrix format used by tm)
npdfmReduced <- npdfmReduced[which(rowSums(npdfmReduced) > 0),]
npdtm <- convert(npdfmReduced, to="topicmodels")


#########################
# Topic Model Estimation
# Estimation, k=200
#########################
# 1. Estimate model
seed1=823 # for reproducibility
tm200 <- LDA(npdtm, k=200, control=list(seed=seed1)) # estimate lda model with 50 topics
probterms200 <- as.data.frame(posterior(tm200)$terms) # all the topic-term probabilities
probtopic200 <- as.data.frame(posterior(tm200)$topics) # all the document-topic probabilities

#  save
save.image("newspaperTopicModelEstimate.RData")
