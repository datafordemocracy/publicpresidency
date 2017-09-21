###################################
# Media Coverage of Trump: NYT, NYP
# Named Entity Recognition
# using spacyr: github.com/kbenoit/spacyr
# Michele Claibourn
# September 18, 2017
###################################

# install latest package from source
# devtools::install_github("kbenoit/spacyr", build_vignettes = FALSE)
rm(list=ls())

# load spacyr
library(spacyr)
spacy_initialize(python_executable = "/anaconda/bin/python3") # point to python

# load additional libraries
library(tidyverse)
library(quanteda)
library(tm)

# Load the data and environment from topicmodelNews.R
setwd("~/Box Sync/mpc/dataForDemocracy/newspaper/")
load("workspaceR/newspaperTopicModel.RData")

# parse texts (may eventually take quanteda corpus as input)
corpus_text <- texts(qcorpus2) # extract text from corpus
parsed_news <- spacy_parse(corpus_text) # pos = T, lemma = T, entity = T

# entity extract (entity consolidate?)
entity_news <- entity_extract(parsed_news)
named_entity_news <- subset(entity_news, entity_type=="PERSON")



save.image("workspaceR/newspaperEntities.RData")
