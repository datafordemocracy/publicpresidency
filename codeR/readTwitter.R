#####################
# Trump Twitter
# Michele Claibourn
# Read in tweets from Trump Twitter Archive
# Jan 20, 2017 through November 20, 2017
#####################

rm(list=ls())
library(quanteda)
library(dplyr)
library(ggplot2)
library(RJSONIO)
library(purrr)

# Directory with tweets
setwd("~/Box Sync/mpc/dataForDemocracy/trumptwitter/")
files <- dir(pattern=".json") # vector of all json file names

# Read in twitter JSON files
test <- fromJSON(files) # read in json file as a list object
tweets2 <- bind_rows(map(test, as.data.frame)) # replaces do.call(rbind, lapply(test, as.data.frame))
str(tweets2)
tweets2$source <- as.factor(tweets2$source)
# Create date variable
library(stringr)
tweets2$date <- paste0(str_sub(tweets2$created_at, 5, 10), ",", str_sub(tweets2$created_at, 27,30))
tweets2$date <- as.Date(tweets2$date, "%b %d,%Y")

# Create a (quanteda) corpus from dataframe
twcorpus <- corpus(tweets2)
summary(twcorpus)

# Save data
save(twcorpus, file="twitter.Rdata")
# load("twitter.RData")


